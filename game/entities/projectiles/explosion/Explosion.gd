class_name Explosion extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var damage: int = 40
var element: Element.Type = Element.Type.Neutral

const DECAY_TIME: float = 0.4

func _ready():
	PolyphonicAudioPlayer.play_sound_effect_from_library("explosion")
	top_level = true
	animation_player.play("SodiumExplosion")
	await get_tree().create_timer(DECAY_TIME).timeout
	queue_free()

func _on_body_entered(body):
	var health_component: HealthComponent = body.get_node_or_null("HealthComponent")
	if health_component:
		health_component.take_damage(damage, element)
