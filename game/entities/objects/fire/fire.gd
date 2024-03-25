class_name  Fire extends RigidBody2D

@export var scale_x: float = 0.1
@export var scale_y: float = 0.1
@export var sprite_texture: Texture
@export var collision_shape: CollisionShape2D
@export var damage_per_tick: int = 4

@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: CollisionShape2D = $CollisionShape2D
@onready var area: CollisionShape2D = $Area2D/CollisionShape2D

var bodys_inside: Array[Object] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.scale.x = scale_x
	sprite.scale.y = scale_y
	hit_box.scale.x = scale_x
	hit_box.scale.y = scale_y
	area.scale.x = scale_x
	area.scale.y = scale_y
	if sprite_texture && collision_shape:
		sprite.texture = sprite_texture
		hit_box.shape = collision_shape.shape
		area.shape = collision_shape.shape
	set_deferred("freeze", true)	
	set_lock_rotation_enabled(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in bodys_inside:
		var health_component: HealthComponent = body.get_node_or_null("HealthComponent")
		if health_component:
			health_component.take_damage(damage_per_tick, Element.Type.Fire)
			body.heat_component.increase_heat(damage_per_tick)

func _on_body_entered(body):
	bodys_inside.append(body)

func _on_body_exited(body):
	bodys_inside.erase(body)
