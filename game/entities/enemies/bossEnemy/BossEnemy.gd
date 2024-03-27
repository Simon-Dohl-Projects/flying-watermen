extends CharacterBody2D

@export var aggro_component: AggroComponent
@export var melee_attack_low_component: MeleeComponent
@export var melee_attack_high_component: MeleeComponent
@export var movement_component: MovementComponent
@export var wall_detection: RayCast2D
@export var fire_wave_cooldown: Timer
@export var attack_cooldown: Timer
@export var change_current_attack: Timer
@export var movement_speed_calm: int = 0
@export var movement_speed_aggro: int = 150
@export var fire_wave_scene: PackedScene
@export var projectile_scene: PackedScene

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var color_rect_low: ColorRect = $MeleeAttackLow/ColorRectLow
@onready var color_rect_high: ColorRect = $MeleeAttackHigh/ColorRectHigh
@onready var fire_detection: Area2D = $FireDetection
@onready var health_component: HealthComponent = $HealthComponent

enum Attacks {FireWave = 600, FireBall = 500, Melee = 300, None = 0}

const ATTACK_DISTANCE: int = 300
const MOVEMENT_EPSILON_PIXELS: int = 230
# Random angle applied to shooting direction is at most SHOOTING_PRECISION
const SHOOTING_PRECISION: float = PI/4
const ATTACK_HINT_TIME: float = 0.3

var next_attack: Attacks = Attacks.None
var is_fire_wave_cd: bool = false
var is_attack_cd: bool = false
var is_in_second_phase: bool = false
var fire_in_range: Array[Object] = []

func _ready():
	aggro_component.aggro_entered.connect(on_aggro_entered)
	aggro_component.calm_entered.connect(on_calm_entered)
	color_rect_low.visible = false
	color_rect_high.visible = false
	fire_detection.collision_mask = 8
	attack_cooldown.wait_time = 1.5
	
func _physics_process(_delta: float):
	var player_distance = abs(player.global_position.x - global_position.x)
	if next_attack == Attacks.None:
		next_attack = choose_attack(player_distance)
		change_current_attack.start()
	else:
		try_attack(player_distance)
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

func choose_attack(_player_distance):
	match randi() % 3:
		0:
			return Attacks.FireBall
		1:
			return Attacks.FireBall
		_:
			return Attacks.FireBall

func try_attack(player_distance):
	if player_distance < next_attack && not is_attack_cd:
		attack(next_attack)
		next_attack = Attacks.None
		is_attack_cd = true
		attack_cooldown.start()

func attack(attack_type):
	match attack_type:
		Attacks.FireWave:
			do_fire_wave()
		Attacks.Melee:
			do_melee_attack()
		Attacks.FireBall:
			do_fire_ball()
		Attacks.None:
			pass

func do_fire_wave():
	if not is_fire_wave_cd:
		var fire_wave_instance = fire_wave_scene.instantiate()
		fire_wave_instance.global_position = global_position
		get_parent().get_parent().add_child(fire_wave_instance)
		is_fire_wave_cd = true
		fire_wave_cooldown.start()

func do_melee_attack():
	if attack_decision():
		color_rect_low.visible = true
		await get_tree().create_timer(ATTACK_HINT_TIME).timeout
		melee_attack_low_component.attack()
		color_rect_low.visible = false
	else:
		color_rect_high.visible = true
		await get_tree().create_timer(ATTACK_HINT_TIME).timeout
		melee_attack_high_component.attack()
		color_rect_high.visible = false

func do_fire_ball():
	for i in range (randi() % 3 + 1):
		shoot_fire_ball()
	
func shoot_fire_ball():
	var projectile: Node2D = projectile_scene.instantiate()
	var projectile_instance: Projectile = projectile.get_node("Projectile")
	var random_angle: float = randf()*SHOOTING_PRECISION - (SHOOTING_PRECISION/2)
	projectile_instance.global_position = global_position
	var direction: Vector2 = Vector2(0, -1)
	projectile_instance.direction = direction.rotated(random_angle)
	get_parent().get_parent().add_child(projectile)
	
func _on_fire_wave_cooldown_timeout():
	is_fire_wave_cd = false

func _on_attack_cooldown_timeout():
	is_attack_cd = false

func attack_decision():
	var ret: bool = player.global_position.y > global_position.y + 100
	if randi() % 5 == 0:
		return not ret
	return ret
	
func _on_change_current_attack_timeout():
	next_attack = Attacks.None


func _on_health_component_health_changed(new_health, delta_health):
	if not is_in_second_phase && new_health < health_component.max_health / 2:
		is_in_second_phase = true
		attack_cooldown.start()
		await get_tree().create_timer(0.2).timeout
		print(fire_in_range)
		for fire in fire_in_range:
			fire.fly_towards(self)
			health_component.heal(50)
			await get_tree().create_timer(0.3).timeout
		attack_cooldown.wait_time = 0.8

func _on_fire_detection_body_entered(body):
	if body is Fire && not fire_in_range.has(body):
		fire_in_range.append(body)
