extends Area2D

@export var min_heat_applied: int = 1
@export var max_heat_applied: int = 3

@onready var collision_shape: CircleShape2D = get_children().filter(func(n): return n is CollisionShape2D)[0].shape
@onready var heat_radius: float = collision_shape.radius

var apply_heat_to: Array[HeatComponent] = []

func _on_body_entered(body: Node2D):
	var heat_component: HeatComponent = body.get_node_or_null("HeatComponent")
	if heat_component:
		apply_heat_to.append(heat_component)

func _on_body_exited(body: Node2D):
	var heat_component: HeatComponent = body.get_node_or_null("HeatComponent")
	if heat_component:
		apply_heat_to.erase(heat_component)

func _on_heat_tick_timeout():
	for heat_component in apply_heat_to:
		var distance: float = global_position.distance_to(heat_component.global_position)
		var heat_weight: float = (heat_radius - distance) /  heat_radius
		var heat_to_apply: int = ceili(lerp(min_heat_applied, max_heat_applied, heat_weight))
		heat_component.increase_heat(heat_to_apply)
