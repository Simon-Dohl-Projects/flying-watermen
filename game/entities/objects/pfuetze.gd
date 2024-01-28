extends Area2D

var health_in_puddle: int = 25

func _on_body_entered(body):
	if body is Player:
		var health_missing: int = body.health_component.max_health - body.health_component.health
		var amount_to_heal: int = mini(health_in_puddle, health_missing)
		body.health_component.heal_over_time(amount_to_heal)
		health_in_puddle -= amount_to_heal
		if health_in_puddle == 0:
			queue_free()
