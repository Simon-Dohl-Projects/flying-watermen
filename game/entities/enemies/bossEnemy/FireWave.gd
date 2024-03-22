class_name FireWave extends Node

@export var damage: int = 40
@export var life_time: float = 2
@export var circle_width: int
@export var timer: Timer

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var OUTER_RADIUS: int = $Sprite2D.texture.get_width() / 2
@onready var INNER_RADIUS: int = OUTER_RADIUS - circle_width
@onready var tics_per_life_time: int = life_time / timer.wait_time

const SIZE_GROWTH: float = 0.04
var current_scale: float = 0.5
var outer_radius: int = OUTER_RADIUS * current_scale
var inner_radius: int = INNER_RADIUS * current_scale
var can_damage: bool = true

func _ready():
	change_scale()

func change_scale():
	self.scale.x = current_scale
	self.scale.y = current_scale
	inner_radius = INNER_RADIUS * current_scale
	outer_radius = OUTER_RADIUS * current_scale

func _on_timer_timeout():
	current_scale += SIZE_GROWTH
	change_scale()
	if can_damage:
		deal_dmg()
	tic_down()

func tic_down():
	tics_per_life_time -= 1
	if tics_per_life_time <= 0:
		queue_free()

func deal_dmg():
	var player_distance: int = (player.global_position - self.global_position).length()
	if inner_radius <= player_distance && player_distance <= outer_radius:
		var health_component: HealthComponent = player.get_node("HealthComponent")
		if not health_component.is_invincible and not health_component.has_iframes:
			health_component.take_damage(damage, Element.Type.Fire)
			player.get_node("HeatComponent").increase_heat(75)
			can_damage = false
