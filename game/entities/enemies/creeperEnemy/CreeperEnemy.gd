extends CharacterBody2D

@export var aggro_component: AggroComponent
@export var movement_component: MovementComponent
@export var wall_detection: RayCast2D
@export var movement_speed_calm: int = 100
@export var movement_speed_aggro: int = 350

@onready var explosion_scene: PackedScene = load("res://entities/projectiles/explosion/Explosion.tscn")
@onready var player: Player = get_tree().get_first_node_in_group("player")

const IGNITE_DISTANCE: int = 200
const IGNATION_DELAY: float = 0.25
const IGNATION_MOVE_SPEED: int = 800
var is_exploding: bool = false

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
	if player_direction == movement_component.Movement_Direction.Right:
		movement_component.change_move_direction(movement_component.Movement_Direction.Right)
	else:
		movement_component.change_move_direction(movement_component.Movement_Direction.Left)

	var player_distance: float = global_position.distance_to(player.global_position)
	if player_distance < IGNITE_DISTANCE and not is_exploding:
		is_exploding = true
		explode()

func explode():
	movement_component.jump(1)
	movement_component.movement_speed = IGNATION_MOVE_SPEED
	await get_tree().create_timer(IGNATION_DELAY).timeout
	var explosion_instance: Explosion = explosion_scene.instantiate()
	explosion_instance.global_position = global_position
	get_parent().add_child(explosion_instance)
	queue_free()

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
