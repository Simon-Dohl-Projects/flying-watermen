@tool
extends Area2D

@export var update: bool = false:
	set(value):
		fit_particle()
@export var force: float = 500
@export var collision_shape: CollisionShape2D:
	set(value):
		collision_shape = value
		fit_particle()

var force_vector: Vector2:
	get: return Vector2(force, 0).rotated(rotation)
var bodys_in_wind_tunnel: Array = []
var shape_size: Vector2:
	get: return collision_shape.shape.size
var shape_global_position: Vector2:
	get: return collision_shape.global_position

func fit_particle():
	if not collision_shape: return
	var partic: GPUParticles2D = $GPUParticles2D
	partic.process_material.set_param_max(0, force)
	partic.process_material.set_param_min(0, force)
	partic.lifetime = shape_size.x / partic.process_material.get_param_max(0)
	partic.process_material.emission_box_extents = Vector3(0, shape_size.y, 0)
	partic.set_visibility_rect(Rect2(Vector2(0,0), shape_size))
	partic.amount = shape_size.y / 4
	global_position = shape_global_position
	collision_shape.position = Vector2(0,0)
	partic.global_position = shape_global_position - Vector2(shape_size.x/2,0).rotated(rotation)

func _physics_process(delta):
	if Engine.is_editor_hint(): return
	for body in bodys_in_wind_tunnel:
		if body is CharacterBody2D:
			_apply_wind_to_char_body(body, delta)
		elif body is RigidBody2D:
			body.apply_impulse(force_vector * delta)

func _apply_wind_to_char_body(body, delta):
	var wind_direction_vel: float = body.velocity.dot(Vector2.from_angle(rotation))
	var wind_force_on_body: float = lerp(wind_direction_vel, force, 0.05)
	var wind_direction_force: float = min(wind_force_on_body, force)
	var orth_wind_direc_vel: float = body.velocity.dot(Vector2.from_angle(rotation + PI/2))
	var new_wind_direction_vel: Vector2 = Vector2(wind_direction_force, 0).rotated(rotation)
	var new_orth_wind_direction_vel: Vector2 = Vector2(orth_wind_direc_vel,0).rotated(rotation+PI/2)
	body.velocity = new_wind_direction_vel + new_orth_wind_direction_vel

func _on_body_entered(body):
	bodys_in_wind_tunnel.append(body)

func _on_body_exited(body):
	if bodys_in_wind_tunnel.has(body):
		bodys_in_wind_tunnel.erase(body)

func _ready():
	fit_particle()
