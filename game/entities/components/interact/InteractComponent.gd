class_name InteractComponent extends Area2D

var interactables_in_range: Array = []
var current_closest_node: Interactable = null:
	set(value):
		if current_closest_node != null: current_closest_node.disable_interact_hint()
		current_closest_node = value
		if current_closest_node: current_closest_node.enable_interact_hint()

func interact() -> void:
	if current_closest_node != null:
		current_closest_node.interact(get_parent())

func _process(_delta: float) -> void:
	var closest_node = get_closest_node()
	if not closest_node == current_closest_node:
		current_closest_node = closest_node

func get_closest_node():
	var closest_node: Interactable = null
	var closest_distance: float = -1
	for node: Interactable in interactables_in_range:
		var distance: float = global_position.distance_to($CollisionShape2D.global_position)
		if not closest_node or distance < closest_distance:
			closest_node = node
			closest_distance = distance
	return closest_node

func _on_area_entered(area: Area2D) -> void:
	if area is Interactable:
		interactables_in_range.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area is Interactable and interactables_in_range.has(area):
		interactables_in_range.erase(area)
