extends Node2D

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var state_chart: StateChart = %StateChart
@onready var animation_tree: AnimationTree = $"../../../Animation/AnimationTree"
@onready var heat_component: HeatComponent:
	get: return player.heat_component

const ICE_FRICTION: float = 0.02

func _ready() -> void:
	player.ready.connect(_on_player_ready)

func _on_player_ready():
	heat_component.heat_changed.connect(_on_heat_component_heat_changed)

# Replace this by depleting the inventory item bar
func _on_heat_component_heat_changed(new_heat: int, _delta_heat: int) -> void:
	if new_heat >= heat_component.MAX_HEAT: player.inventory.use_active_item(1)

func _on_ice_state_entered():
	heat_component.heat = 0
	player.friction = ICE_FRICTION
	player.health_component.is_invincible = true
	player.disenable_components(false, false, false)
	$"../../../MonitorEffects".get_node("Freeze").visible = true
	animation_tree["parameters/conditions/entered_ice"] = true
	animation_tree["parameters/conditions/exited_ice"] = false

	player.direction = 0

func _on_ice_state_exited() -> void:
	heat_component.heat = 0
	player.friction = player.base_friction
	player.health_component.is_invincible = false
	player.disenable_components(true, true, true)
	$"../../../MonitorEffects".get_node("Freeze").visible = false
	animation_tree["parameters/conditions/entered_ice"] = false
	animation_tree["parameters/conditions/exited_ice"] = true
