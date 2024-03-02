extends RigidBody2D

@export var sprite: Texture
@export var collision_shape: CollisionShape2D
@export var damage_per_tick: int = 4

var bodys_inside: Array[Object] 

# Called when the node enters the scene tree for the first time.
func _ready():
	if sprite && collision_shape:
		$Sprite2D.texture = sprite
		$CollisionShape2D.shape = collision_shape.shape
		$Area2D/CollisionShape2D.shape = collision_shape.shape
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
