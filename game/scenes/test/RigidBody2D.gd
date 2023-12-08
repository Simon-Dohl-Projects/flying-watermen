extends RigidBody2D

var x = 0
# Called when the node enters the scene tree for the first time.
func take_damage():
	print(x)
	x += 1
