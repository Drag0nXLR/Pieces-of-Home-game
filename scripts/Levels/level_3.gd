extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LanguageManager._update_current_scene_labels()
	GlobalVars.spawnpoint=Vector2(344,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
