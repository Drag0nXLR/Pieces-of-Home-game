extends Node

# Масив шляхів до сцен у порядку проходження
const LEVELS = [
	preload("res://scenes/Levels/game.tscn"),
	preload("res://scenes/Transitions_and_Cutscenes/cutscene.tscn"),
	preload("res://scenes/Levels/level_2.tscn"),
	preload("res://scenes/Levels/level_3.tscn"),
	preload("res://scenes/Transitions_and_Cutscenes/cutscene2.tscn"),
	preload("res://scenes/Menus/main_menu.tscn")
]

var current_level_index: int = 0

func go_to_next_level() -> String:
	
	# Спочатку збільшуємо індекс, щоб він вказував на наступну сцену
	
	
	if current_level_index < LEVELS.size():
		var next_scene_packed = LEVELS[current_level_index]
		
		print("Перехід до індексу: ", current_level_index, " (", next_scene_packed.resource_path, ")")
		current_level_index += 1
		return next_scene_packed.resource_path # <-- Повертаємо шлях до наступної сцени
		
	else:
		# Всі сцени послідовності пройдені. Це кінець гри.
		print("Всі рівні послідовності пройдені.")
		
		# 1. Скидаємо індекс для наступного запуску
		current_level_index = 0
		
		# 2. Не повертаємо шлях! Або повертаємо порожній рядок, щоб зупинити перехід.
		# Якщо ви викликали цю функцію з Головного меню, це запобігає автоматичному рестарту.
		return "" # Повертаємо порожній рядок (або помилку), щоб головний менеджер зупинився.
