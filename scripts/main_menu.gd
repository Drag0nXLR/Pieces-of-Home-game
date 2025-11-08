extends Control

func _on_start_pressed() -> void:
	LevelTransition.start_transition()
	LanguageManager._update_current_scene_labels()

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menus/settings.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
