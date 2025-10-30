extends Control

@onready var fullscreen_toggle: CheckBox = $MarginContainer/VBoxContainer/FullscreenMode
@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/Volume
@onready var resolution_select: OptionButton = $MarginContainer/VBoxContainer/Resolution
@onready var mute: CheckBox = $MarginContainer/VBoxContainer/Mute

func _ready() -> void:
	update_ui_from_settings()

func update_ui_from_settings() -> void:
	var s = SettingsManager.settings

	# 🔹 Гучність
	volume_slider.value = s["volume"]
	AudioServer.set_bus_volume_db(0, linear_to_db(s["volume"])) # ✅ ось ця лінія

	# 🔹 Повноекранний режим
	fullscreen_toggle.button_pressed = s["fullscreen"]
	
	mute.button_pressed = s["muted"]
	AudioServer.set_bus_mute(0, s["muted"])

	# 🔹 Роздільність (знаходимо індекс)
	match s["resolution"]:
		Vector2i(1920, 1080):
			resolution_select.select(0)
		Vector2i(1600, 900):
			resolution_select.select(1)
		Vector2i(1280, 720):
			resolution_select.select(2)
		_:
			resolution_select.select(2) # за замовчуванням

func _on_volume_value_changed(value: float) -> void:
	SettingsManager.settings["volume"] = value
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	SettingsManager.save_settings()

func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

func set_window_size_centered_on_current_screen(new_size: Vector2i) -> void:
	var screen_id = DisplayServer.window_get_current_screen()
	var screen_size = DisplayServer.screen_get_size(screen_id)
	var centered_pos = (screen_size - new_size) / 2 + DisplayServer.screen_get_position(screen_id)

	DisplayServer.window_set_size(new_size)
	DisplayServer.window_set_position(centered_pos)
	DisplayServer.window_set_current_screen(screen_id)

func _on_resolution_item_selected(index: int) -> void:
	var res = Vector2i.ZERO
	match index:
		0: res = Vector2i(1920, 1080)
		1: res = Vector2i(1600, 900)
		2: res = Vector2i(1280, 720)
	SettingsManager.settings["resolution"] = res
	set_window_size_centered_on_current_screen(res)
	SettingsManager.save_settings()

func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_fullscreen_mode_toggled(toggled_on: bool) -> void:
	SettingsManager.settings["fullscreen"] = toggled_on
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	SettingsManager.save_settings()
