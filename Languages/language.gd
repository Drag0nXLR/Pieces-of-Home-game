# LanguageManager.gd
# Додати у Project Settings -> Autoload

extends Node
var ukrainian_font : Font = preload("res://assets/Font/Tiny5-Regular.ttf")
var default_label_font : Font = null
var default_button_font : Font = null
var current_language = "English"
var last_scene: Node = null
var language_dict = {
	"Welcome!
AD Left Right are to move.
Space or W to jump 
Hold shift to sprint
You can also double-jump": {
		"English":"Welcome!
AD Left Right are to move.
Space or W to jump 
Hold shift to sprint
You can also double-jump",
		"Українська":"Ласкаво просимо!A та D або стрілки — щоб рухатися.Пробіл або W — щоб стрибнути.Утримуй Shift, щоб бігти.Ти також можеш зробити подвійний стрибок.",
		"Deutsch":"Willkommen!A und D oder die Pfeiltasten – zum Bewegen.Leertaste oder W – zum Springen.Halte Shift gedrückt, um zu rennen.Du kannst auch einen Doppelsprung machen."
	},
	"Start Adventure": {
		"English":"Start Adventure",
		"Українська":"Почати пригоду",
		"Deutsch":"Abenteuer starten"
	},
	"Settings": {
		"English":"Settings",
		"Українська":"Налаштування",
		"Deutsch":"Einstellungen"
	},
	"Quit": {
		"English":"Quit",
		"Українська":"Вийти",
		"Deutsch":"Beenden"
	},
	"--SETTINGS--": {
		"English":"--SETTINGS--",
		"Українська":"--Налаштування--",
		"Deutsch":"--Einstellungen--"
	},
	"Change Volume": {
	"English":"Change Volume",
	"Українська":"Змінити гучність",
	"Deutsch":"Lautstärke ändern"
},
	"Mute Game": {
		"English":"Mute Game",
		"Українська":"Вимкнути звук гри",
		"Deutsch":"Spiel stummschalten"
	},
	"Mute": {
		"English":"Mute",
		"Українська":"Вимкнути звук гри",
		"Deutsch":"Spiel stummschalten"
	},
	"Fullscreen Mode": {
		"English":"Fullscreen Mode",
		"Українська":"Повноекранний режим",
		"Deutsch":"Vollbildmodus"
	},
	"Back": {
		"English":"Back",
		"Українська":"Назад",
		"Deutsch":"Zurück"
	},
	"Don`t fall down :)
You won`t get away": {
		"English":"Don`t fall down :)
You won`t get away",
		"Українська":"Не впади :)
		Тобі не втекти",
		"Deutsch":"Fall nicht runter :)
		Du wirst nicht entkommen"
	},
	"WOW! What a cute monster!
Could that cute thing hurt you?": {
		"English":"WOW! What a cute monster!
Could that cute thing hurt you?",
		"Українська":"ВАУ! Який милий монстр!
		Невже ця мила штука може тебе поранити?",
		"Deutsch":"WOW! Was für ein süßes Monster!
		Könnte dieses niedliche Ding dich verletzen?"
	},
	"You`ve fallen down... That`s your choice...": {
		"English":"You`ve fallen down... That`s your choice...",
		"Українська":"Ти впав... Це твій вибір...",
		"Deutsch":"Du bist gefallen... Das war deine Entscheidung..."
	},
	"You got 0 parts of broken ship": {
		"English":"You got 0 parts of broken ship",
		"Українська":"Ти отримав 0 частин зламаного корабля",
		"Deutsch":"Du hast 0 Teile des kaputten Schiffs gefunden"
	},
	"You won’t make it.": {
		"English":"You won’t make it.",
		"Українська":"У тебе не вийде.",
		"Deutsch":"Du wirst es nicht schaffen."
	},
	"Someone better already did it.": {
		"English":"Someone better already did it.",
		"Українська":"Хтось кращий вже зробив це.",
		"Deutsch":"Jemand Besseres hat es schon gemacht."
	},
	"You’re not good enough.": {
		"English":"You’re not good enough.",
		"Українська":"Ти недостатньо хороший.",
		"Deutsch":"Du bist nicht gut genug."
	},
	"You’ll quit, like always.": {
		"English":"You’ll quit, like always.",
		"Українська":"Ти кинеш, як завжди.",
		"Deutsch":"Du wirst aufgeben, wie immer."
	},
	"Why even try?": {
		"English":"Why even try?",
		"Українська":"Навіщо навіть намагатись?",
		"Deutsch":"Warum überhaupt versuchen?"
	},
	"DONT ENTER....
Or do.": {
	"English":"DONT ENTER....
Or do.",
	"Українська":"НЕ ВХОДЬ.... 
	Або входи.",
	"Deutsch":"NICHT EINTRETEN.... Oder tu es."
},
	"Wait!,isnt this just the same world?": {
		"English":"Wait!isn't this just the same world?",
		"Українська":"Зачекай! Хіба це не той самий світ?",
		"Deutsch":"Warte! Ist das nicht einfach die gleiche Welt?"
	},
	"Go,and find out": {
		"English":"Go, and find out",
		"Українська":"Іди і дізнайся",
		"Deutsch":"Geh und finde es heraus"
	},
	"Resume": {
		"English":"Resume",
		"Українська":"Продовжити",
		"Deutsch":"Fortsetzen"
	},
	"Main Menu": {
		"English":"Main Menu",
		"Українська":"Головне меню",
		"Deutsch":"Hauptmenü"
	},
	"==VOLUME==": {
		"English":"==VOLUME==",
		"Українська":"==Гучність==",
		"Deutsch":"==LAUTSTÄRKE=="
	},
	"You got ... of 20 parts of broken ship": {
	"English":"You got ... of 20 parts of broken ship",
	"Українська":"Ти отримав ... з 20 частин зламаного корабля",
	"Deutsch":"Du hast ... von 20 Teilen des kaputten Schiffs"
}

}

func _ready():
	# просто оновлюємо поточну сцену на старті
	_update_current_scene_labels()

func _process(_delta):
	# Автоматично оновлюємо тексти, якщо сцена змінилася
	var current_scene = get_tree().current_scene
	if current_scene != last_scene and current_scene != null:
		last_scene = current_scene
		_update_labels_and_buttons(current_scene)

func set_language(lang: String):
	current_language = lang
	if last_scene:
		_update_labels_and_buttons(last_scene)

func reset_to_english():
	current_language = "English"
	if last_scene:
		_update_labels_and_buttons(last_scene)

func _update_current_scene_labels():
	var scene = get_tree().current_scene
	if scene:
		last_scene = scene
		_update_labels_and_buttons(scene)

func _update_labels_and_buttons(node: Node):
	if node is Label:
		var key = node.text.strip_edges()
		if key in language_dict:
			node.text = language_dict[key][current_language]

		# Зміна шрифта через Custom Fonts
		if current_language == "Українська":
			node.add_theme_font_override("font", ukrainian_font)
		else:
			if default_label_font == null:
				default_label_font = node.get_theme_font("font")
			if default_label_font != null:
				node.add_theme_font_override("font", default_label_font)

	elif node is Button:
		var key = node.text.strip_edges()
		if key in language_dict:
			node.text = language_dict[key][current_language]

		if current_language == "Українська":
			node.add_theme_font_override("font", ukrainian_font)
		else:
			if default_button_font == null:
				default_button_font = node.get_theme_font("font")
			if default_button_font != null:
				node.add_theme_font_override("font", default_button_font)

	for child in node.get_children():
		_update_labels_and_buttons(child)
