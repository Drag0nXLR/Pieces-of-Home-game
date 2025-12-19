# phase_manager.gd
extends Node

class_name PhaseManager

var current_phase = 0
var phase_nodes = []

func _ready():
	for child in get_children():
		if child.name.begins_with("Phase"):
			phase_nodes.append(child)
	
	# Pass the boss (parent) to start_phase
	start_phase(0, get_parent())

func start_phase(phase_index, boss_instance = null):
	# Disable all phases
	for phase in phase_nodes:
		phase.set_process(false)
		phase.set_physics_process(false)
	
	# Enable the target phase
	if phase_index < phase_nodes.size():
		current_phase = phase_index
		var target_phase = phase_nodes[phase_index]
		target_phase.set_process(true)
		target_phase.set_physics_process(true)
		# Pass the boss instance to the phase
		target_phase.start_phase(boss_instance)

func get_current_phase_node():
	if current_phase < phase_nodes.size():
		return phase_nodes[current_phase]
	return null
