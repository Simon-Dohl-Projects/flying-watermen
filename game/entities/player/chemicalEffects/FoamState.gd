extends Node2D

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var state_chart: StateChart = %StateChart

var has_automatic_cooldown: float = 0.0
var shooting_cooldown: float = 0.07

func _on_foam_state_entered():
	player.projectile_scene = load("res://entities/projectiles/FoamProjectile.tscn")
	player.ranged_component.shot.connect(shooting_cost)
	player.ranged_component.cooldown = shooting_cooldown

func _on_foam_state_processing(_delta):
	if Input.is_action_pressed("right_click"):
		player.shoot()

func shooting_cost() -> void:
	player.inventory.use_active_item(1)

func _on_foam_state_exited():
	if player.is_shooting_Water:
		player.projectile_scene = load("res://entities/projectiles/WaterProjectile.tscn")
		player.ranged_component.cooldown = player.ranged_component.base_cooldown
	else:
		player.projectile_scene = load("res://entities/projectiles/BuildingFoamProjectile.tscn")
		player.ranged_component.cooldown = player.buildingFoam_shootcooldown
	player.ranged_component.shot.disconnect(shooting_cost)
