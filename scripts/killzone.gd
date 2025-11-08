extends Area2D

@onready var timer: Timer = $Timer
var pl
func _on_body_entered(body):
	pl=body
	print("You died!")
	Engine.time_scale = 0.7
	#body.get_node("CollisionShape2D").queue_free()
	#body.animated_sprite.play("death")
	
	# Wait a bit, adjust to your death animation length
	timer.start(0.03)
	
	# body.get_node("CollisionShape2D").queue_free()
	pl.position=GlobalVars.spawnpoint
	#pl.is_dead=false
func _on_timer_timeout():
	Engine.time_scale = 1
	
