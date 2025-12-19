extends Node2D

@onready var score_label: Label = $CanvasLayer/Score_label
var params: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.current_level_index = 6
	GlobalVars.invis = false
	GlobalVars.score = 15
	score_label.text = LanguageManager.language_dict["You got ... of 20 parts of broken ship"][LanguageManager.current_language].replace("...",str(GlobalVars.score))
	LanguageManager._update_current_scene_labels()
	GlobalVars.spawnpoint=Vector2(53,698)
