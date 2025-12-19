extends CharacterBody2D

enum PHASES { PHASE_1, PHASE_2, PHASE_3 }

var current_phase = PHASES.PHASE_1
var health = 600
var max_health = 600
var phase_thresholds = [0.65, 0.35]

var is_invulnerable = false
var can_take_damage = true
var phase_transitioning = false

var speed = 150.0
var jump_power = 300.0
var gravity = 800.0
var jump_frequency = 1.5
var last_jump_time = 0.0

@onready var hurtbox: Area2D = $HurtBox
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar = $CanvasLayer/UI/HealthBar
@onready var phase_manager = $PhaseManager

func _ready():
	add_to_group("Boss")
	hurtbox.add_to_group("BossHurtbox")
	health_bar.max_value = max_health
	health_bar.value = health
	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("idle"):
		animated_sprite.play("idle")

# =============================
# DAMAGE HANDLING
# =============================
func take_damage(damage: int) -> void:
	if is_invulnerable or health <= 0:
		return

	if not can_take_damage:
		return

	can_take_damage = false
	health -= damage
	health = max(health, 0)
	update_health_bar()

	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("hurt"):
		animated_sprite.play("hurt")
	else:
		update_idle_animation()

	if health <= 0:
		die()
		return

	# Cooldown before next damage
	await get_tree().create_timer(0.3).timeout
	can_take_damage = true

# =============================
# ANIMATION
# =============================
func _on_AnimatedSprite2D_animation_finished() -> void:
	if animated_sprite.animation == "hurt":
		update_idle_animation()

func die() -> void:
	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("death"):
		animated_sprite.play("death")
	
	# Wait 1 second before changing the scene
	await get_tree().create_timer(1.0).timeout
	
	# Change to your cutscene scene
	get_tree().change_scene_to_file("res://scenes/Transitions_and_Cutscenes/cutscene4.tscn")
	
	queue_free() # Optional: free the boss node if you want

# =============================
# AI / MOVEMENT
# =============================
func _physics_process(delta):
	if is_invulnerable:
		print("Boss invulnerable! Phase: ", current_phase)

	if health <= 0:
		return

	if not phase_transitioning:
		update_phases()

	var player = get_player()
	if not player:
		return

	var direction = (player.global_position - global_position).normalized()

	if is_on_floor():
		if Time.get_ticks_msec() / 1000.0 - last_jump_time > jump_frequency:
			if player.global_position.distance_to(global_position) > 30:
				velocity.x = direction.x * speed
				velocity.y = -jump_power
				last_jump_time = Time.get_ticks_msec() / 1000.0

				if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("jump"):
					animated_sprite.play("jump")

				move_and_slide()
	else:
		velocity.y += gravity * delta
		move_and_slide()

	if abs(velocity.x) > 10:
		animated_sprite.flip_h = velocity.x < 0

# =============================
# PHASES / UI
# =============================
func update_health_bar():
	var tween = create_tween()
	tween.tween_property(health_bar, "value", health, 0.3)

func update_phases():
	var health_percent := float(health) / float(max_health)

	if current_phase == PHASES.PHASE_1 and health_percent <= phase_thresholds[0]:
		_start_phase_transition(PHASES.PHASE_2)
	elif current_phase == PHASES.PHASE_2 and health_percent <= phase_thresholds[1]:
		_start_phase_transition(PHASES.PHASE_3)

# =============================
# Phase transition using async
# =============================
func _start_phase_transition(new_phase):
	if new_phase == current_phase or phase_transitioning:
		return

	phase_transitioning = true
	is_invulnerable = true
	current_phase = new_phase

	# Start phase transition coroutine
	_phase_transition_coroutine(new_phase)

# Note: async function in Godot 4
func _phase_transition_coroutine(new_phase) -> void:
	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("phase_transition"):
		animated_sprite.play("phase_transition")
		await animated_sprite.animation_finished
	else:
		animated_sprite.modulate = Color.YELLOW
		await get_tree().create_timer(0.3).timeout
		animated_sprite.modulate = Color.WHITE

	update_idle_animation()
	phase_manager.start_phase(new_phase)

	match new_phase:
		PHASES.PHASE_2:
			speed = 200.0
			jump_power = 350.0
			jump_frequency = 1.2
		PHASES.PHASE_3:
			speed = 250.0
			jump_power = 400.0
			jump_frequency = 0.8

	is_invulnerable = false
	phase_transitioning = false	

func update_idle_animation():
	var anim := "idle"
	if current_phase == PHASES.PHASE_2 and animated_sprite.sprite_frames.has_animation("idle_phase_2"):
		anim = "idle_phase_2"
	elif current_phase == PHASES.PHASE_3 and animated_sprite.sprite_frames.has_animation("idle_phase_3"):
		anim = "idle_phase_3"

	if animated_sprite.sprite_frames.has_animation(anim):
		animated_sprite.play(anim)

func get_player():
	return get_tree().get_first_node_in_group("Player")
