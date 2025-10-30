extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body):
	print("You died!")
	Engine.time_scale = 0.7
	body.get_node("CollisionShape2D").queue_free()
	body.die()

	# Wait a bit, adjust to your death animation length
	timer.start(0.7)

	# body.get_node("CollisionShape2D").queue_free()

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
