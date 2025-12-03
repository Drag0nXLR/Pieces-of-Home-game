extends Node2D

@onready var tip_label: Label = $CanvasLayer/Tip
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@export_file("*.tscn") var next_scene_path: String
@export var params: Dictionary
var progress = []
var scene_load_status : int = 0

func get_random_tip() -> String:
	return GlobalVars.tips[randi() % GlobalVars.tips.size()]

func show_random_tip() -> void:
	# Tween для fade-out
	var tween = create_tween()
	tween.tween_property(tip_label, "modulate:a", 0.0, 0.5)
	tween.finished.connect(Callable(self, "_on_fade_out_complete"))

func _on_fade_out_complete() -> void:
	# Міняємо текст на нову випадкову пораду
	tip_label.text = get_random_tip()
	
	# Tween для fade-in
	var tween = create_tween()
	tween.tween_property(tip_label, "modulate:a", 1.0, 0.5)
	tween.finished.connect(Callable(self, "_on_fade_in_complete"))

func _on_fade_in_complete() -> void:
	# Почекати tip_interval секунд і показати наступну пораду
	await get_tree().create_timer(3).timeout
	show_random_tip()

func _ready():
	randomize()
	show_random_tip()
	ResourceLoader.load_threaded_request(next_scene_path)

func _process(_delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
	progress_bar.value = floor(progress[0]*100)

	if ResourceLoader.load_threaded_get_status(next_scene_path) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		_transition()

# Ця функція впорається із затримкою та переходом
func _transition() -> void:
	#await get_tree().create_timer(20).timeout
	var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path)
	var new_node = new_scene.instantiate()
	new_node.params = params
	var current_scene = get_tree().current_scene
	get_tree().get_root().add_child(new_node)
	get_tree().current_scene = new_node
	current_scene.queue_free()
