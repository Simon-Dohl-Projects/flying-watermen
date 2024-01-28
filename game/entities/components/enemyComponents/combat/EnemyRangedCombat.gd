extends Node2D

@export var projectile_scene: PackedScene
@export var aggro_component: AggroComponent

@onready var player: Player = get_tree().get_first_node_in_group("player")

# Random angle applied to shooting direction is at most SHOOTING_PRECISION
const SHOOTING_PRECISION: float = PI/12
# Angle in radians that gets applied to equalize for gravity
const ANGLE_CORRECTION: float = PI/10

var can_shoot: bool = true

func _ready():
	aggro_component.aggro_entered.connect(func(): can_shoot = true)
	aggro_component.calm_entered.connect(func(): can_shoot = false)

func _on_fire_rate_timeout():
	if can_shoot:
		var projectile: Node2D = projectile_scene.instantiate()
		var projectile_instance: Projectile = projectile.get_node("Projectile")
		var random_angle: float = randf()*SHOOTING_PRECISION - (SHOOTING_PRECISION/2)
		projectile_instance.global_position = global_position
		var direction: Vector2 = global_position.direction_to(player.global_position)
		var corrected_direction: Vector2 = direction.rotated(ANGLE_CORRECTION * -sign(direction.x))
		projectile_instance.direction = corrected_direction.rotated(random_angle)
		get_parent().get_parent().add_child(projectile)
