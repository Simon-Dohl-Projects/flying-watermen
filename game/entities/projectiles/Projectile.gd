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

var velocity_offset: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var start_parent: Node = get_parent()

var time:float = 0.0

func _ready():
	visible = false
	top_level = true
	hitbox.collision_mask = new_collision_mask
	if collision_shape:
		hitbox_shape.set_shape(collision_shape.shape)
		collision_shape.queue_free()
	if sprite:
		$Sprite2D.queue_free()
		sprite.reparent.call_deferred(self)
	set_linear_velocity((direction * speed) + velocity_offset)
	await get_tree().create_timer(life_time_seconds).timeout
	queue_free()

func _integrate_forces(state):
	rotation = linear_velocity.angle()
	if not visible: visible = true

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
	tween.tween_method(_set_blink, 1.0, life_time_seconds / 2, life_time_seconds) # args are: (method to call / start value / end value / duration of animation)

# tween value automatically gets passed into this function
func _set_blink(value: float):
	var sinTime = 0
	var blink_speed = value
	sinTime = abs(sin(blink_speed * time))
	if time >= 5.0: modulate.a = 0.3 + 0.7 * sinTime

func _on_tree_entered():
	var parent_projectile = get_parent().get_parent()#.find_child("Projectile", false)
	if parent_projectile is Projectile: return
	else: if freeze: _set_tween()
		#var distance_to_parent: Vector2 =  parent_projectile.global_position - global_position
		#distance_to_parent *= (1 /(distance_to_parent.length())) * 20
		#print(distance_to_parent)
		#global_position =  parent_projectile.global_position #- distance_to_parent
		#print("Parent_pos:" + str(parent_projectile.global_position))
		#print("Self_pos:" + str(global_position))
		#print("")
		#self_modulate.a = parent_projectile.self_modulate.a
		#material = parent_projectile.material

func _process(delta):
	time += delta
