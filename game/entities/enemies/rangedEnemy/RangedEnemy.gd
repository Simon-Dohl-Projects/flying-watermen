extends CharacterBody2D

@export var movement_component: MovementComponent
@export var movement_speed_calm: int = 100
@export var movement_speed_aggro: int = 250

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var aggro_component: AggroComponent = $AggroComponent
@onready var ranged_component: RangedComponent = $RangedComponent
@onready var ground_distance: RayCast2D = $GroundDistance

## When the enemy is directly above the player it stops movement
# idk what to name this...
const MOVEMENT_EPSILON_PIXELS: int = 50
## Random angle applied to shooting direction is at most SHOOTING_PRECISION
const SHOOTING_PRECISION: float = PI/12
## Angle in radians that gets applied to equalize for gravity
const ANGLE_CORRECTION: float = PI/10
var projectile: PackedScene = load("res://entities/projectiles/FireProjectile.tscn")

func _ready():
	aggro_component.aggro_entered.connect(on_aggro_entered)
	aggro_component.calm_entered.connect(on_calm_entered)

func _physics_process(_delta: float):
	if ground_distance.is_colliding():
		movement_component.jump(1)

	if not aggro_component.is_aggro:
		return

	shoot()
	var player_distance: float = abs(player.global_position.x - global_position.x)
	var player_direction: int = sign(player.global_position.x - global_position.x)
	if player_distance < MOVEMENT_EPSILON_PIXELS:
		movement_component.movement_direction = movement_component.Movement_Direction.No
		return
	if player_direction == movement_component.Movement_Direction.Right:
		movement_component.change_move_direction(movement_component.Movement_Direction.Right)
	else:
		movement_component.change_move_direction(movement_component.Movement_Direction.Left)

func on_aggro_entered():
	movement_component.movement_speed = movement_speed_aggro

func on_calm_entered():
	movement_component.movement_speed = movement_speed_calm

func _on_movement_oscillation_timeout():
	if not aggro_component.is_aggro:
		movement_component.flip_move_direction()

func shoot():
	var random_angle: float = randf()*SHOOTING_PRECISION - (SHOOTING_PRECISION/2)
	var direction: Vector2 = global_position.direction_to(player.global_position)
	var corrected_direction: Vector2 = direction.rotated(ANGLE_CORRECTION * -sign(direction.x))
	ranged_component.shoot(corrected_direction.rotated(random_angle), projectile, Vector2(0,0))
