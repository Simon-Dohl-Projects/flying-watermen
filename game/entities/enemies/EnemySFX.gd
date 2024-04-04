extends Node2D

func _on_melee_component_melee_attack_started():
	PolyphonicAudioPlayer.play_sound_effect_from_library("melee_enemy_attack")

func _on_ranged_component_projectile_shoot():
	PolyphonicAudioPlayer.play_sound_effect_from_library("ranged_enemy_attack")
