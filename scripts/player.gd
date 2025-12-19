extends CharacterBody2D

var speed = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var attack_hitbox: Area2D = $AttackHitbox

var is_dead = false
var is_running = false
var is_double_jumping = false
var max_jumps = 2
var is_attacking = false
var attack_has_hit = false

var jumps_left: int
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

func _on_AttackHitbox_area_entered(area: Area2D) -> void:
	if not is_attacking:
		return

	if attack_has_hit:
		return

	if not area.is_in_group("BossHurtbox"):
		return

	var boss = area.get_parent()
	if boss and boss.has_method("take_damage"):
		attack_has_hit = true
		boss.take_damage(randi_range(15, 35))

func _on_AnimatedSprite2D_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		attack_hitbox.monitoring = false
		$AttackHitbox/CollisionShape2D.disabled = true
		is_attacking = false

func toggle_invis():
	if not GlobalVars.invis:
		animated_sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
		GlobalVars.invis = true
	else:
		animated_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		GlobalVars.invis = false
	print(GlobalVars.invis)

func walk_anim():
	animated_sprite.play("walk")

func run_anim():
	animated_sprite.play("run")

func die():
	animated_sprite.play("death")

func play_attack_animation() -> void:
	if is_attacking:
		return

	is_attacking = true
	attack_has_hit = false
	attack_hitbox.monitoring = true
	$AttackHitbox/CollisionShape2D.disabled = false
	animated_sprite.play("attack")

func _ready():
	print(SceneManager.current_level_index)
	jumps_left = max_jumps
	add_to_group("Player")
	attack_hitbox.add_to_group("PlayerAttack")
	attack_hitbox.monitoring = false
	$AttackHitbox/CollisionShape2D.disabled = true

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps_left = max_jumps
		is_double_jumping = false
	
	# Handle attack input
	if Input.is_action_just_pressed("attack"):
		play_attack_animation()
	
	# Toggle invis
	if Input.is_action_just_pressed("toggle_invisible"):
		toggle_invis()
	
	# Jump
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1
		audio.play()
	
	if jumps_left == max_jumps - 1:
		is_double_jumping = false
	elif jumps_left == 0:
		is_double_jumping = true
	
	# Run
	if Input.is_action_just_pressed("run"):
		is_running = true
		speed = 230
	elif Input.is_action_just_released("run"):
		is_running = false
		speed = 130
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# =========================
	# ANIMATION LOGIC (FIXED)
	# =========================
	if not is_attacking:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				if not is_running:
					animated_sprite.play("walk")
				else:
					animated_sprite.play("run")
		else:
			if is_double_jumping:
				animated_sprite.play("double_jump")
			else:
				animated_sprite.play("jump")
	
	# Movement (optional freeze during attack)
	if is_attacking:
		velocity.x = 0
	else:
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
