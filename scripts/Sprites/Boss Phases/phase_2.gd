extends Node

var boss: CharacterBody2D

func start_phase(boss_instance):
	boss = boss_instance
	if boss == null:
		push_error("Boss not found!")
		return

	boss.speed = 90.0 # Phase 2, 90 for Phase 3
	boss.update_idle_animation()
