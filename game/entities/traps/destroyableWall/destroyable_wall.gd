class_name DestroyableWall extends RigidBody2D

@export var sprite: Texture
@export var collision_shape: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = sprite
	$CollisionShape2D.shape = collision_shape.shape
	$Area2D/CollisionShape2D.shape = collision_shape.shape
	set_deferred("freeze", true)

func _on_area_2d_area_entered(area):
	if area is Explosion:
		set_deferred("freeze", false)
		collision_mask = 0
