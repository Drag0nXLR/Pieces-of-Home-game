# phase_1.gd
extends Node

var boss: CharacterBody2D = null

func start_phase(boss_instance):
	boss = boss_instance
	
	if boss == null:
		push_error("Could not find boss!")
		return
	
	boss.speed = 50.0
	print("Phase 1: Basic slime behavior")
	
	if boss.animated_sprite \
	and boss.animated_sprite.sprite_frames \
	and boss.animated_sprite.sprite_frames.has_animation("idle"):
		boss.animated_sprite.play("idle")
