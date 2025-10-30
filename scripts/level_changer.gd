extends Area2D

@onready var level_transition = get_node("/root/LevelTransition") # або відносний шлях

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		print("debug")
		level_transition.call_deferred("start_transition", "res://scenes/cutscene.tscn")
