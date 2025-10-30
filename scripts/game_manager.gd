extends Node

var score = 0

@onready var score_label: Label = $"../CanvasLayer/Score_label"

func _ready():
	SettingsManager.apply_settings()

func add_point():
	score += 1
	score_label.text = "You got " + str(score) + " of 20 parts of broken ship"
