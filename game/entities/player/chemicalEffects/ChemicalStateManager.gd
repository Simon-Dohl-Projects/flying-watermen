class_name ChemicalStateManager extends Node

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var state_chart: StateChart = %StateChart

signal ice_entered()

func _ready() -> void:
	player.ready.connect(connect_inventory)

func _input(event: InputEvent):
	if event.is_action_pressed("activate_item"):
		if player.inventory.active_item:
			var active_chemical: String = player.inventory.active_item.name
			state_chart.set_expression_property("active_chemical", active_chemical)
			state_chart.send_event("to_chemical")
	if event.is_action_pressed("exit_state"):
		state_chart.send_event("to_default")
		player.inventory.set_active_item(null)

func connect_inventory() -> void:
	player.inventory.on_item_used.connect(check_item_left)

func check_item_left(_left, _max) -> void:
	if player.inventory.active_item_left == 0:
		state_chart.send_event("to_default")


func _on_ice_state_entered() -> void:
	ice_entered.emit()
