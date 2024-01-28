extends Node2D

@onready var player: Player = $".."
@onready var walk_particles: GPUParticles2D = $WalkingParticles
@onready var dash_particles: GPUParticles2D = $DashTrail

var walk: Resource = ResourceLoader.load("res://entities/player/assets/fliped_walk_test.png")
var run: Resource = ResourceLoader.load("res://entities/player/assets/runanimation/run02.png")

func walking_particles():
	# y > 80 wegen den Wallslides 
	if abs(player.velocity.x) > 20 || abs(player.velocity.y) > 80 :
		walk_particles.set_amount_ratio(1)
	else:
		walk_particles.set_amount_ratio(0.2)
		
func dash_trail():
	# need the if to flip the sprite
	if player.velocity.x > 0:
		dash_particles.emitting = true
		dash_particles.texture = walk
	else:
		dash_particles.emitting = true
		dash_particles.texture = run

