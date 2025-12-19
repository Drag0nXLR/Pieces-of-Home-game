extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		await get_tree().create_timer(1).timeout
		SceneManager.current_level_index = 0
		get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
