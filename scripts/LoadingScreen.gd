extends Node2D

@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@export_file("*.tscn") var next_scene_path: String
@export var params: Dictionary
var progress = []
var scene_load_status : int = 0

func _ready():
	ResourceLoader.load_threaded_request(next_scene_path)

func _process(_delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
	progress_bar.value = floor(progress[0]*100)

	if ResourceLoader.load_threaded_get_status(next_scene_path) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		_transition()

# Ця функція впорається із затримкою та переходом
func _transition() -> void:
	var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path)
	var new_node = new_scene.instantiate()
	new_node.params = params
	var current_scene = get_tree().current_scene
	get_tree().get_root().add_child(new_node)
	get_tree().current_scene = new_node
	current_scene.queue_free()
