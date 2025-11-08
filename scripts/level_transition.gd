extends CanvasLayer

# --- Ноди ---
@onready var texture_rect: TextureRect = $TextureRect

# --- Змінні ---
var shader_mat: ShaderMaterial
var next_scene: String

func _ready():
	# Перевіряємо TextureRect
	if texture_rect == null:
		push_error("TextureRect not found! Check node path.")
		return
	
	# Призначаємо ShaderMaterial, якщо його немає
	if texture_rect.material == null:
		shader_mat = ShaderMaterial.new()
		shader_mat.shader = preload("res://shaders/pixelate.gdshader")
		texture_rect.material = shader_mat
	else:
		shader_mat = texture_rect.material as ShaderMaterial
	
	# Приховуємо TextureRect на початку
	hide()

func start_transition():
	next_scene = SceneManager.go_to_next_level()
	show()

	# --- Створюємо СТАТИЧНИЙ знімок екрана (Виправлення) ---

	# 1. Отримуємо "живу" текстуру в'юпорта
	var viewport_texture: ViewportTexture = get_viewport().get_texture()

	# 2. Копіюємо її дані в Image (це копія з GPU на CPU)
	var image: Image = viewport_texture.get_image()

	# 3. Створюємо нову, незалежну текстуру з цих даних
	var static_snapshot: ImageTexture = ImageTexture.create_from_image(image)

	# 4. Призначаємо цю статичну текстуру нашому TextureRect
	texture_rect.texture = static_snapshot

	# --- Кінець виправлення ---

	# Розтягуємо TextureRect на весь екран через код
	texture_rect.size = get_viewport().get_visible_rect().size

	# --- Tween пікселізації ---
	var tween = create_tween()
	# Встановлюємо початкове значення (якщо воно не 1.0)
	shader_mat.set_shader_parameter("pixel_size", 1.0) 
	# Анімуємо
	tween.tween_property(shader_mat, "shader_parameter/pixel_size", 300.0, 0.5) # Збільшення пікселів
	tween.tween_callback(Callable(self, "_change_scene"))


func _change_scene():
	# Зміна сцени
	print("Next scene path:", next_scene)
	get_tree().change_scene_to_file(next_scene)
	call_deferred("_reverse_transition")

func _reverse_transition():
	var tween = create_tween()
	tween.tween_property(shader_mat, "shader_parameter/pixel_size", 1.0, 0.5) # Зменшення пікселів
	tween.tween_callback(Callable(self, "hide"))
