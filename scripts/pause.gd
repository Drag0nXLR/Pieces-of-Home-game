extends Control

@onready var settings: Control = $PauseSettings
@onready var pause_menu: PanelContainer = $PanelContainer
@onready var resume_btn: Button = $PanelContainer/VBoxContainer/Resume
@onready var settings_btn: Button = $PanelContainer/VBoxContainer/Settings
@onready var quit_btn: Button = $PanelContainer/VBoxContainer/Quit
@onready var color_rect: ColorRect = $ColorRect
@onready var settings_menu: Control = $PauseSettings

@onready var volume_slider: HSlider = $PauseSettings/VBoxContainer/ScrollContainer/VBoxContainer/Volume
@onready var mute: CheckBox = $PauseSettings/VBoxContainer/ScrollContainer/VBoxContainer/Mute

func _ready() -> void:
	load_ui_from_settings()
	LanguageManager._update_current_scene_labels()

func load_ui_from_settings():
	var s = SettingsManager.settings
	
	volume_slider.value = s["volume"]
	AudioServer.set_bus_volume_db(0, linear_to_db(s["volume"]))
	
	mute.button_pressed = s["muted"]
	AudioServer.set_bus_mute(0, s["muted"])

func resume():
	resume_btn.release_focus()
	quit_btn.release_focus()
	settings_btn.release_focus()
	
	color_rect.hide()
	resume_btn.hide()
	quit_btn.hide()
	settings_btn.hide()
	get_tree().paused = false
	$AnimationPlayer.play_backwards("pause")

func pause():
	get_tree().paused = true
	color_rect.show()
	resume_btn.show()
	quit_btn.show()
	settings_btn.show()
	$AnimationPlayer.play("pause")

func esc():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()


func _on_resume_pressed() -> void:
	resume()

func _on_settings_pressed() -> void:
	settings.show()
	pause_menu.hide()

func _on_quit_pressed() -> void:
	SceneManager.current_level_index-=1
	$AnimationPlayer.play_backwards("pause")
	resume_btn.release_focus()
	quit_btn.release_focus()
	settings_btn.release_focus()
	color_rect.hide()
	resume_btn.hide()
	quit_btn.hide()
	settings_btn.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")

func _on_back_pressed() -> void:
	settings.hide()
	pause_menu.show()


func _on_volume_value_changed(value: float) -> void:
	SettingsManager.settings["volume"] = value
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	SettingsManager.save_settings()

func _on_mute_toggled(toggled_on: bool) -> void:
	SettingsManager.settings["muted"] = toggled_on
	AudioServer.set_bus_mute(0, toggled_on)
	SettingsManager.save_settings()

func _process(_delta: float):
	esc()


func _on_keybinds_pressed() -> void:
	settings_menu.add_child(preload("res://scenes/Menus/keybinds.tscn").instantiate())
