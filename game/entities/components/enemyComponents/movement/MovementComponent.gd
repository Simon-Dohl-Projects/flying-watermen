class_name MovementComponent extends Node2D

@export var movement_speed: int = 100
@export var jump_force: int = -500
@export var can_fly: bool = false
@export var weight: float = 1
@export var nodes_to_flip: Array[Node2D] = []

@onready var body: CharacterBody2D = get_parent()

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
enum Movement_Direction { Left = -1, Right = 1, No = 0 }
var movement_direction: Movement_Direction = Movement_Direction.Right

func _physics_process(delta):
	if not body.is_on_floor():
		body.velocity.y += gravity * weight * delta
	body.velocity.x = movement_speed * movement_direction;
	body.move_and_slide()

func jump(intensity: float):
	if body.is_on_floor() or can_fly:
		body.velocity.y = intensity * jump_force

func change_move_direction(direction: Movement_Direction):
	movement_direction = direction
	for node in nodes_to_flip:
		node.scale.x = movement_direction

func flip_move_direction():
	if movement_direction == Movement_Direction.Left:
		change_move_direction(Movement_Direction.Right)
	else:
		change_move_direction(Movement_Direction.Left)
