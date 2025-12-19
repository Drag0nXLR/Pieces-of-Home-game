extends Node2D


func music_change():
	Music.change_music("res://assets/time_for_adventure.mp3")

func change_level():
	get_tree().change_scene_to_file("res://scenes/Transitions_and_Cutscenes/credits.tscn")
