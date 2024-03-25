extends CharacterBody2D

@export var aggro_component: AggroComponent
@export var melee_attack_low_component: MeleeComponent
@export var melee_attack_high_component: MeleeComponent
@export var movement_component: MovementComponent
@export var wall_detection: RayCast2D
@export var fire_wave_cooldown: Timer
@export var melee_cooldown: Timer
@export var movement_speed_calm: int = 0
@export var movement_speed_aggro: int = 150
@export var fire_wave_scene: PackedScene

@onready var player: Player = get_tree().get_first_node_in_group("player")

enum Attacks {FireWave = 600, Melee = 300, None = 0}
const ATTACK_DISTANCE: int = 300
const MOVEMENT_EPSILON_PIXELS: int = 230
var next_attack: Attacks = Attacks.FireWave
var is_fire_wave_cd: bool = false
var is_melee_cd: bool = false

func _ready():
	aggro_component.aggro_entered.connect(on_aggro_entered)
	aggro_component.calm_entered.connect(on_calm_entered)

func _physics_process(_delta: float):
	var player_distance = abs(player.global_position.x - global_position.x)
	if next_attack == null:
		next_attack = high_level_KI(player_distance)
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

# retard naming :/
func high_level_KI(_player_distance):
	if randi() % 2:
		return Attacks.Melee
	return Attacks.FireWave

func try_attack(player_distance):
	if player_distance < next_attack:
		attack(next_attack)
		next_attack = Attacks.None

func attack(attack_type):
	match attack_type:
		Attacks.FireWave:
			do_fire_wave()
		Attacks.Melee:
			do_melee_attack()
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
	if not is_melee_cd:
		if attack_decision():
			melee_attack_low_component.attack()
		else:
			melee_attack_high_component.attack()
		is_melee_cd = true
		melee_cooldown.start() 

func _on_fire_wave_cooldown_timeout():
	is_fire_wave_cd = false
	
func _on_melee_cooldown_timeout():
	is_melee_cd = false

func attack_decision():
	if randi() % 2:
		return true
	return false
