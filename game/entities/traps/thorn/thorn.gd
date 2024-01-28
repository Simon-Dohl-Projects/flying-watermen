extends Sprite2D

#@onready var health_component: HealthComponent = $HealthComponent
@onready var player: Player = get_tree().get_first_node_in_group("player")

const damage: int = 10
var has_body_inside: bool = false
var can_deal_damage: bool = false

#func _ready():
	#$Area2D/Timer.start()

func _process(delta):
	if has_body_inside && can_deal_damage:
		player.health_component.take_damage(damage,Element.Type.Neutral)
		can_deal_damage = false

func _on_area_2d_body_entered(body):
	if body == player:
		has_body_inside = true
		$Area2D/Timer.start()

func _on_area_2d_body_exited(body):
	if body == player:
		has_body_inside = false
		$Area2D/Timer.stop()

func _on_timer_timeout():
	can_deal_damage = true
