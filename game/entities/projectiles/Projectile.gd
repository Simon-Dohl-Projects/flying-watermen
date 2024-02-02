class_name Projectile extends RigidBody2D

@export var element: Element.Type = Element.Type.Water
@export var speed: int = 1500
@export var damage: int = 20
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var new_collision_mask: int = 5
@export var is_sticky: bool = false
@export var life_time_seconds: int = 4

@onready var hitbox: Area2D = $Area2D
@onready var hitbox_shape: CollisionShape2D = $Area2D/CollisionShape2D

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity_offset: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO

func _ready():
	top_level = true
	hitbox.collision_mask = new_collision_mask
	if collision_shape:
		hitbox_shape.set_shape(collision_shape.shape)
		collision_shape.queue_free()
	if sprite: $Sprite2D.queue_free()
	set_linear_velocity((direction * speed) + velocity_offset)
	await get_tree().create_timer(life_time_seconds).timeout
	queue_free()

func _on_area_2d_body_entered(body):
	var health_component: HealthComponent = body.get_node_or_null("HealthComponent")
	if !is_sticky:
		if health_component:
			health_component.take_damage(damage, element)
		if body is Player and element != Element.Type.Water:
			body.heat_component.increase_heat(damage)
		queue_free()
	else:
		if health_component:
			health_component.take_damage_overtime(damage, element, 30)
		linear_velocity = Vector2(0, 0)
		gravity_scale = 0
		var curr_pos: Vector2 = global_position
		top_level = false
		get_parent().call_deferred("reparent", body)
		await get_tree().process_frame
		global_position = curr_pos

func _on_tree_exiting() -> void:
	if not get_parent().get_script(): get_parent().queue_free()