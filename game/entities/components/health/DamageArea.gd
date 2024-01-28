extends Area2D

@export var min_damage: int = 1
@export var max_damage: int = 3
@export var element: Element.Type

@onready var collision_shape: CircleShape2D = get_children().filter(func(n): return n is CollisionShape2D)[0].shape
@onready var damage_radius: float = collision_shape.radius

var apply_damage_to: Array[HealthComponent] = []

func _on_body_entered(body: Node2D):
	var health_component: HealthComponent = body.get_node_or_null("HealthComponent")
	if health_component:
		apply_damage_to.append(health_component)

func _on_body_exited(body: Node2D):
	var health_component: HealthComponent = body.get_node_or_null("HealthComponent")
	if health_component:
		apply_damage_to.erase(health_component)

func _on_damage_tick_timeout():
	for health_component in apply_damage_to:
		var distance: float = global_position.distance_to(health_component.global_position)
		var damage_weight: float = (damage_radius - distance) /  damage_radius
		var damage_to_apply: int = ceili(lerp(min_damage, max_damage, damage_weight))
		health_component.take_damage(damage_to_apply, element)
