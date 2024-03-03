class_name  Fire extends RigidBody2D

@export var scale_x: float = 0.1
@export var scale_y: float = 0.1
@export var sprite: Texture
@export var collision_shape: CollisionShape2D
@export var damage_per_tick: int = 4

@onready var Sprite = $Sprite2D
@onready var CollisionShape = $CollisionShape2D
@onready var Area = $Area2D/CollisionShape2D

var bodys_inside: Array[Object] 

# Called when the node enters the scene tree for the first time.
func _ready():
	Sprite.scale.x = scale_x
	Sprite.scale.y = scale_y
	CollisionShape.scale.x = scale_x
	CollisionShape.scale.y = scale_y
	Area.scale.x = scale_x
	Area.scale.y = scale_y
	if sprite && collision_shape:
		Sprite.texture = sprite
		CollisionShape.shape = collision_shape.shape
		Area.shape = collision_shape.shape
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
