class_name Projectile extends RigidBody2D

@export var element: Element.Type = Element.Type.Water
@export var speed: int = 1500
@export var damage: int = 20
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var new_collision_mask: int = 5
@export var is_sticky: bool = false
@export var life_time_seconds: int = 4

@onready var hitbox: Area2D = $Area2D
@onready var hitbox_shape: CollisionShape2D = $Area2D/CollisionShape2D

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity_offset: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var start_parent: Node = get_parent()


func _ready():
	top_level = true
	hitbox.collision_mask = new_collision_mask
	if collision_shape:
		hitbox_shape.set_shape(collision_shape.shape)
		collision_shape.queue_free()
	if sprite: $Sprite2D.queue_free()
	set_linear_velocity((direction * speed) + velocity_offset)
	await get_tree().create_timer(life_time_seconds).timeout
	queue_free()

func _on_area_2d_body_entered(body):
	if freeze: return
	var health_component: HealthComponent = body.get_node_or_null("HealthComponent")
	if !is_sticky:
		if health_component:
			health_component.take_damage(damage, element)
		if body is Player and element != Element.Type.Water:
			body.heat_component.increase_heat(damage)
		queue_free()
	else:
		if health_component:
			health_component.take_damage_overtime(damage, element, 30)
		#_set_tween()
		call_deferred("set_freeze_enabled", true)
		var curr_pos: Vector2 = global_position
		top_level = false
		collision_layer = 1
		global_position = curr_pos
		get_parent().call_deferred("reparent", body)

# Removes parent if it's only a placeholder for the projectile scene
func _on_tree_exiting() -> void:
	if start_parent == get_parent() and not get_parent().get_script():
		get_parent().queue_free()

func _set_tween():
	var tween = get_tree().create_tween()
	var float_life_time_seconds: float = life_time_seconds
	#tween.tween_method(_set_fade_away, 1.0, life_time_seconds, life_time_seconds) # args are: (method to call / start value / end value / duration of animation)

# tween value automatically gets passed into this function
func _set_fade_away(value: float):
	print(255 * abs(sin(value)))
	#modulate = Color(255, 255, 255,55 + 200 * abs(sin(value)))
	#set("self_modulate", )
	# in my case i'm tweening a shader on a texture rect, but you can use anything with a material on it
	#life_time_seconds = value
	#material.set("shader_parameter/blink_speed", value);

func _on_tree_entered():
	var parent_projectile = get_parent().get_parent()#.find_child("Projectile", false)
	if parent_projectile is Projectile:
		#var distance_to_parent: Vector2 =  parent_projectile.global_position - global_position
		#distance_to_parent *= (1 /(distance_to_parent.length())) * 20
		#print(distance_to_parent)
		#global_position =  parent_projectile.global_position #- distance_to_parent
		#print("Parent_pos:" + str(parent_projectile.global_position))
		#print("Self_pos:" + str(global_position))
		#print("")
		material = parent_projectile.material
