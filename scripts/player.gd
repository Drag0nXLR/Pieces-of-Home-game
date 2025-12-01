extends CharacterBody2D


var speed = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var is_dead = false
var is_running = false
var is_double_jumping = false
var max_jumps = 2

var jumps_left: int
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

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

func _ready():
	jumps_left = max_jumps

func _physics_process(delta: float) -> void:
	if not is_dead:
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		else:
			jumps_left = max_jumps
			is_double_jumping = false
		# Handle jump.
		if Input.is_action_just_pressed("toggle invisible"):
			toggle_invis()

		if Input.is_action_just_pressed("jump") and jumps_left > 0:
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1
			audio.play()
		if jumps_left == max_jumps - 1:
			is_double_jumping = false
		elif jumps_left == 0:
			is_double_jumping = true
		
		if Input.is_action_just_pressed("run"):
			is_running = true
			speed = 230
		
		elif Input.is_action_just_released("run"):
			is_running = false
			speed = 130

		#input direction 1 0 or -1
		var direction := Input.get_axis("move_left", "move_right")
		
		if direction > 0:
			animated_sprite.flip_h = false
		
		elif direction < 0:
			animated_sprite.flip_h = true
		
		# Play animation
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				if not is_running:
					animated_sprite.play("walk")
				elif is_running:
					animated_sprite.play("run")
		else:
			if is_double_jumping:
				animated_sprite.play("double_jump")
			
			elif not is_double_jumping:
				animated_sprite.play("jump")
		
		
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

		move_and_slide()
