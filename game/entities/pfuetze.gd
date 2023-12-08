extends Area2D

var player_inside = false 
var player 

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"): 
		player_inside = true
		player = body 

func _on_body_exited(body):
	if body == player:
		player_inside = false
		player = null 

func _process(delta):
	if player_inside and player: 
		player.heal_over_time(25) 
		self.queue_free()
