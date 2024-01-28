extends Node2D

@export var carried_item: PackedScene
@onready var health_component: HealthComponent = get_parent().get_node_or_null("HealthComponent")

func _ready():
	if health_component:
		health_component.death.connect(drop_item)
	else:
		push_warning("No health component found!")

func drop_item():
	if carried_item:
		call_deferred("spawn_item")

func spawn_item():
	var collectable_instance: Node2D = carried_item.instantiate()
	collectable_instance.global_position = global_position
	get_parent().get_parent().add_child(collectable_instance)

