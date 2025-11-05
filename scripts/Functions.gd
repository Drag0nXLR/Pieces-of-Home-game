extends Node

func load_screen_to_scene(target: String, params: Dictionary = {}) -> void:
	var loading_screen = preload("res://scenes/Menus/loading_screen.tscn").instantiate()
	loading_screen.next_scene_path = target
	loading_screen.params = params
	get_tree().current_scene.add_child(loading_screen)
