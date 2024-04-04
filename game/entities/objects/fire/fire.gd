@tool
class_name  Fire extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: CollisionShape2D = $CollisionShape2D
@onready var area: CollisionShape2D = $Area2D/CollisionShape2D

@export var fire_scale: Vector2 = Vector2(0.3, 0.3):
	get:
		return fire_scale
	set(value):
		fire_scale = value
		$Sprite2D.scale = fire_scale
		$CollisionShape2D.scale = fire_scale
		$Area2D/CollisionShape2D.scale = fire_scale
@export var sprite_texture: Texture:
	get:
		return sprite_texture
	set(value):
		sprite_texture = value
		sprite.texture = sprite_texture
@export var collision_shape: CollisionShape2D:
	get:
		return collision_shape
	set(value):
		collision_shape = value
		hit_box.shape = collision_shape.shape
		area.shape = collision_shape.shape
@export var damage_per_tick: int = 4



var bodys_inside: Array[Object] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.scale = fire_scale
	hit_box.scale = fire_scale
	area.scale = fire_scale
	set_deferred("freeze", true)
	#set_lock_rotation_enabled(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not Engine.is_editor_hint():
		for body in bodys_inside:
			var health_component: HealthComponent = body.get_node_or_null("HealthComponent")
			apply_fire_tick(body, health_component)

func apply_fire_tick(body, health_component):
	if health_component:
		health_component.take_damage(damage_per_tick, Element.Type.Fire)
		body.heat_component.increase_heat(damage_per_tick)

func _on_body_entered(body):
	bodys_inside.append(body)

func _on_body_exited(body):
	bodys_inside.erase(body)

func fly_towards(body):
	$Area2D.collision_mask = 0
	var tween = create_tween()
	tween.tween_property(self, "position", body.global_position, 0.3)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
	tween.finished.connect(self.queue_free)

func _on_health_component_health_changed(new_health, _delta_health):
	var tween = create_tween()
	var new_alpha: float= (30 + new_health)
	tween.tween_property(sprite, "modulate:a", new_alpha / 100, 0.2)
