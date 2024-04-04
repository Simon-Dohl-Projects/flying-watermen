extends Node2D

@export var carried_item: Array[PackedScene] = []
@onready var health_component: HealthComponent = get_parent().get_node_or_null("HealthComponent")
@export_range(0, 1) var spawn_probability: float

func _ready():
	if health_component:
		health_component.death.connect(drop_item)
	else:
		push_warning("No health component found!")

func drop_item():
	if carried_item:
		call_deferred("spawn_item")

func spawn_item():
	if randf_range(0,1) <= spawn_probability:
		var collectable_instance: Node2D = carried_item.pick_random().instantiate()
		collectable_instance.global_position = global_position
		get_tree().get_first_node_in_group("map").add_child(collectable_instance)
