extends Node2D

var params: Dictionary

func _ready():
	print(params)
	LanguageManager._update_current_scene_labels()
	GlobalVars.spawnpoint=Vector2(1,0)
