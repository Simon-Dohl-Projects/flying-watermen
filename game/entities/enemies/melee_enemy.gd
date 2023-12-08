extends CharacterBody2D

var isAggro = false

const CALM_MOVEMENT_SPEED = 100
const AGGRO_MOVEMENT_SPEED = 400
const MOVEMENT_TURBULENCE = 0.01
var calm_direction = -1

const JUMP_VELOCITY = -500
const JUMP_COOLDOWN = 0.5
var last_jump = 0

const MAX_DAMAGE_DISTANCE = 300
const DISTANCE_MULTIPLIER = 100
const HEAT_INFLICTION_PER_SECOND = 10
const DAMAGE_PER_SECOND = 10
const DAMAGE_INTERVAL_SECONDS = 0.1
var damage_timer = 0

# reverse dependency?
@onready var playerBody: CharacterBody2D = get_tree().get_root().get_node("Main").get_node("Player")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall():
		jump()
	last_jump += delta
	check_damage(delta)
	move()

func jump():
	if last_jump > JUMP_COOLDOWN:
		velocity.y = JUMP_VELOCITY
		last_jump = 0

func move():
	if isAggro:
		aggro_movement()
	else:
		calm_movement()
	move_and_slide()

func calm_movement():
	var random = randf()
	if random < MOVEMENT_TURBULENCE:
		calm_direction *= -1
	velocity.x = CALM_MOVEMENT_SPEED * calm_direction;

func aggro_movement():
	var aggro_direction = sign(playerBody.global_position.x - global_position.x)
	velocity.x = AGGRO_MOVEMENT_SPEED * aggro_direction;

func _on_aggro_collider_body_entered(body: CharacterBody2D):
	isAggro = true

func _on_aggro_collider_body_exited(body: CharacterBody2D):
	isAggro = false

func deal_distance_damage(distance_to_player: float, delta):
	var heat: int = ceili((DISTANCE_MULTIPLIER/distance_to_player) * HEAT_INFLICTION_PER_SECOND * DAMAGE_INTERVAL_SECONDS)
	damage_timer += delta
	if playerBody.has_method("increase_heat") and (damage_timer >= DAMAGE_INTERVAL_SECONDS):
		playerBody.increase_heat(heat)
		playerBody.damage_with_scaling(DAMAGE_PER_SECOND * DAMAGE_INTERVAL_SECONDS)
		damage_timer = 0

func check_damage(delta):
	var player_position = playerBody.global_position
	var distance_to_player = global_position.distance_to(player_position)
	if distance_to_player < MAX_DAMAGE_DISTANCE:
		deal_distance_damage(distance_to_player, delta)
