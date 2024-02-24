extends CharacterBody2D

@export var aggro_component: AggroComponent
@export var melee_component: MeleeComponent
@export var movement_component: MovementComponent
@export var wall_detection: RayCast2D
@export var movement_speed_calm: int = 100
@export var movement_speed_aggro: int = 250

@onready var player: Player = get_tree().get_first_node_in_group("player")

const ATTACK_DISTANCE: int = 300
const MOVEMENT_EPSILON_PIXELS: int = 50

func _ready():
	aggro_component.aggro_entered.connect(on_aggro_entered)
	aggro_component.calm_entered.connect(on_calm_entered)

func _physics_process(_delta: float):
	hunt_player() if aggro_component.is_aggro else idle_movement()

func idle_movement():
	if wall_detection.is_colliding():
		movement_component.flip_move_direction()

func hunt_player():
	if wall_detection.is_colliding():
		movement_component.jump(1)
	var player_direction: int = sign(player.global_position.x - global_position.x)
	var player_distance: float = abs(player.global_position.x - global_position.x)
	if abs(player_distance) < MOVEMENT_EPSILON_PIXELS:
		movement_component.movement_direction = movement_component.Movement_Direction.No
		return
	if player_direction == movement_component.Movement_Direction.Right:
		movement_component.change_move_direction(movement_component.Movement_Direction.Right)
	else:
		movement_component.change_move_direction(movement_component.Movement_Direction.Left)

func on_aggro_entered():
	# This introduces the little jump
	movement_component.jump(0.2)
	movement_component.movement_speed = 0
	await get_tree().create_timer(0.4).timeout
	movement_component.movement_speed = movement_speed_aggro

func on_calm_entered():
	movement_component.movement_speed = movement_speed_calm

func flash_damage_effect():
	$DirectionalNodes/EnemyGraphics/FlameImage.set("shader_parameter/flash_modifier", 1)

func _on_attack_frequency_timeout():
	var player_distance: float = player.global_position.distance_to(global_position)
	if aggro_component.is_aggro and player_distance < ATTACK_DISTANCE:
			melee_component.attack()
