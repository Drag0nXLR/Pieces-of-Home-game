extends Area2D

@onready var level_transition = get_node("/root/LevelTransition") # або відносний шлях

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		if SceneManager.current_level_index == 1:
			if GlobalVars.score >= 4:
				level_transition.call_deferred("start_transition")
		if SceneManager.current_level_index == 3:
			if GlobalVars.score >= 10:
				level_transition.call_deferred("start_transition")
		if SceneManager.current_level_index == 4:
			if GlobalVars.score >= 15:
				level_transition.call_deferred("start_transition")
		if SceneManager.current_level_index == 6:
			if GlobalVars.score >= 19:
				level_transition.call_deferred("start_transition")
		print("Transition to: " + str(LevelTransition.next_scene))
