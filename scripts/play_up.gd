extends Node
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


func _on_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		animation_player.play("up")
