extends Node

var settings = {
	"resolution": Vector2i(1280, 720),
	"fullscreen": false,
	"volume": 1.0,
	"muted": false,
}

const SAVE_PATH = "user://settings.cfg"

func _ready():
	load_settings()
	apply_settings()

func save_settings() -> void:
	var config = ConfigFile.new()
	for key in settings.keys():
		config.set_value("graphics", key, settings[key])
	config.save(SAVE_PATH)

func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	if err == OK:
		for key in settings.keys():
			settings[key] = config.get_value("graphics", key, settings[key])

func apply_settings() -> void:
	if settings["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
		# Встановлюємо розмір і центруємо вікно
		set_window_size_centered_on_current_screen(settings["resolution"])
	
	AudioServer.set_bus_volume_db(0, linear_to_db(settings["volume"]))
	
	AudioServer.set_bus_mute(0, settings["muted"])

func set_window_size_centered_on_current_screen(new_size: Vector2i) -> void:
	var screen_id = DisplayServer.window_get_current_screen()
	var screen_size = DisplayServer.screen_get_size(screen_id)
	var screen_pos = DisplayServer.screen_get_position(screen_id)
	
	var centered_pos = screen_pos + (screen_size - new_size) / 2
	
	DisplayServer.window_set_size(new_size)
	DisplayServer.window_set_position(centered_pos)
	DisplayServer.window_set_current_screen(screen_id)
