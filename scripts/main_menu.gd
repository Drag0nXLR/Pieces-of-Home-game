extends Control
@onready var texture_rect: TextureRect = $TextureRect
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var label: Label = $Label

func _ready():
	$VBoxContainer/Start.grab_focus()


func _on_start_pressed() -> void:
	Functions.load_screen_to_scene(SceneManager.go_to_next_level(), {"Load": "scene"})
	texture_rect.hide()
	v_box_container.hide()
	label.hide()
	LanguageManager._update_current_scene_labels()

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menus/settings.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
