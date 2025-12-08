extends Node

var config := ConfigFile.new()

# -----------------------------
#	ГРАФІЧНІ НАЛАШТУВАННЯ
# -----------------------------
var settings = {
	"resolution": Vector2i(1280, 720),
	"fullscreen": false,
	"volume": 1.0,
	"muted": false,
}

# -----------------------------
#	KEYBINDS
# -----------------------------
var keybinds := {
	"move_left": "A",
	"move_right": "D",
	"jump": "W",
	"run": "shift",
	"toggle_invisible": "I",
	"attack": "Q",
}

# -----------------------------
const SAVE_PATH := "user://settings.cfg"

func _ready():
	load_settings()
	apply_settings()
	save_settings()	# Щоб створити файл при першому запуску


# =============================
#	ЗБЕРЕЖЕННЯ
# =============================
func save_settings() -> void:
	# Зберігаємо графіку
	for key in settings.keys():
		config.set_value("graphics", key, settings[key])

	config.save(SAVE_PATH)

func save_keybinding(action: StringName, event: InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
	
	config.set_value("keybinding", action, event_str)
	config.save(SAVE_PATH)

# =============================
#	ЗАВАНТАЖЕННЯ
# =============================
func load_settings() -> void:
	var err := config.load(SAVE_PATH)

	if err == OK:
		# Графіка
		for key in settings.keys():
			settings[key] = config.get_value("graphics", key, settings[key])

		# Кейбінди
		var loaded = load_keybindings()
		for key in loaded.keys():
			keybinds[key] = loaded[key]

func load_keybindings():
	var keybindings = {}
	var keys = config.get_section_keys("keybinding")
	for key in keys:
		var input_event
		var event_str = config.get_value("keybinding", key)
		
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
		keybindings[key] = input_event
	return keybindings

# =============================
#	ЗАСТОСУВАННЯ НАЛАШТУВАНЬ
# =============================
func apply_settings() -> void:
	if settings["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		set_window_size_centered_on_current_screen(settings["resolution"])

	AudioServer.set_bus_volume_db(0, linear_to_db(settings["volume"]))
	AudioServer.set_bus_mute(0, settings["muted"])


# =============================
#	Центрування вікна
# =============================
func set_window_size_centered_on_current_screen(new_size: Vector2i) -> void:
	var screen_id = DisplayServer.window_get_current_screen()
	var screen_size = DisplayServer.screen_get_size(screen_id)
	var screen_pos = DisplayServer.screen_get_position(screen_id)

	var centered_pos = screen_pos + (screen_size - new_size) / 2

	DisplayServer.window_set_size(new_size)
	DisplayServer.window_set_position(centered_pos)
	DisplayServer.window_set_current_screen(screen_id)
