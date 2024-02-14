extends Control

@onready var debugger: Control = %StateChartDebugger
@onready var player: Player = get_tree().get_first_node_in_group("player")

var is_hovered: bool = false

func _ready():
	debugger.debug_node(player.state_chart)

#func _on_flying_toggled(toggled_on: bool) -> void:
	#player.gravity = 0 if toggled_on else player.base_gravity
	#player.jumps = 0 if toggled_on else player.base_jumps

func _on_invicibility_toggled(toggled_on: bool) -> void:
	player.health_component.is_invincible = toggled_on
