extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LanguageManager._update_current_scene_labels()
	GlobalVars.spawnpoint=Vector2(360,0)
