extends Node2D


func level4():
	SceneManager.current_level_index += 1
	get_tree().change_scene_to_file("res://scenes/Levels/level_4.tscn")
