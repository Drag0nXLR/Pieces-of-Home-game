extends Control

func _on_start_pressed() -> void:
	Functions.load_screen_to_scene("res://scenes/Levels/game.tscn", {"test": "test"})

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menus/settings.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
