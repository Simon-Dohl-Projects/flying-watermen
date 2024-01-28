class_name SodiumProjectile extends Node2D

const EXPLOSION_SCENE: PackedScene = preload("res://entities/projectiles/explosion/Explosion.tscn")

func spawn_explosion(_placeholder):
	pass

func _on_projectile_tree_exiting() -> void:
	var explosion_instance: Explosion = EXPLOSION_SCENE.instantiate()
	var current_pos: Vector2 = $Projectile.global_position
	explosion_instance.position = current_pos
	# This call deferred is needed to prevent a weird godot error being thrown
	get_parent().call_deferred("add_child", explosion_instance)
	await get_tree().process_frame
	queue_free()
