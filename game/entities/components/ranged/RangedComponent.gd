class_name RangedComponent extends Node2D

signal shot()

@export var use_cooldown: bool = false
@export var base_cooldown: float = 0.5
var cooldown: float = base_cooldown

@onready var timer: Timer = $ShootCooldown
@onready var shoot_position: Marker2D = $ShootPosition
var is_enabled: bool = true:
	set(value):
		if not value: timer.stop()
		is_enabled = value

func shoot(direction: Vector2, projectile: PackedScene, velocity_offset: Vector2):
	if is_enabled:
		var projectile_node: Node2D = projectile.instantiate()
		var projectile_instance: Projectile = projectile_node.get_node("Projectile")
		projectile_instance.position = shoot_position.global_position
		projectile_instance.direction = direction
		projectile_instance.velocity_offset = velocity_offset
		add_child(projectile_node)
		shot.emit()
		if use_cooldown:
			disable()
			timer.wait_time = cooldown
			timer.start()

func disable():
	is_enabled = false

func enable():
	is_enabled = true

func disable_timer():
	use_cooldown = false

func enable_timer():
	use_cooldown = true
