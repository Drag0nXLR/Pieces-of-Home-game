extends Node



@onready var score_label: Label = $"../CanvasLayer/Score_label"

func _ready():
	SettingsManager.apply_settings()
	score_label.text=GlobalVars.score_text

func add_point():
	GlobalVars.score += 1
	score_label.text = LanguageManager.language_dict["You got ... of 20 parts of broken ship"][LanguageManager.current_language].replace("...",str(GlobalVars.score))
	GlobalVars.score_text=score_label.text
