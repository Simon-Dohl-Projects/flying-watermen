extends Node2D

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var state_chart: StateChart = %StateChart

const SODIUM_DAMAGE: int = 5

func _on_sodium_state_entered() -> void:
	player.projectile_scene = load("res://entities/projectiles/sodium/SodiumProjectile.tscn")
	player.ranged_component.shot.connect(shooting_cost)

func _on_sodium_state_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		player.shoot()

func shooting_cost() -> void:
	player.health_component.take_damage(SODIUM_DAMAGE, Element.Type.Neutral)
	player.inventory.use_active_item(1)

func _on_sodium_state_exited() -> void:
	player.projectile_scene = load("res://entities/projectiles/WaterProjectile.tscn")
	player.ranged_component.shot.disconnect(shooting_cost)
