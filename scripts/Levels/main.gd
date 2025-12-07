extends Node2D

@onready var score_label: Label = $CanvasLayer/Score_label
var params: Dictionary

func _ready():
	GlobalVars.score = 0
	score_label.text = LanguageManager.language_dict["You got ... of 20 parts of broken ship"][LanguageManager.current_language].replace("...",str(GlobalVars.score))
	LanguageManager._update_current_scene_labels()
	GlobalVars.spawnpoint=Vector2(1,0)
	if SceneManager.current_level_index != 1:
		SceneManager.current_level_index = 1
