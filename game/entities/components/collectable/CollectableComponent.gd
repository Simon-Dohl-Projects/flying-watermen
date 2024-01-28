class_name Collectable extends Node2D

@export var item: Item

@onready var collect_area: Area2D = $CollectArea
@onready var pick_up_hint: PanelContainer = $PanelContainer

const COLLECT_DURATION: float = 0.03
var player_in_radius: Player = null

func _ready():
	pick_up_hint.visible = false
	collect_area.body_entered.connect(_body_entered)
	collect_area.body_exited.connect(_body_exited)

func _input(event):
	if event.is_action_pressed("interact") and player_in_radius:
		player_in_radius.inventory.set_item_in_inventory(item)
		var tween = create_tween()
		tween.tween_property(get_parent(), "position", player_in_radius.position, COLLECT_DURATION)
		tween.tween_property(get_parent(), "scale", Vector2.ZERO, COLLECT_DURATION)
		tween.finished.connect(get_parent().queue_free)

func _body_entered(body):
	if body is Player:
		pick_up_hint.visible = true
		player_in_radius = body

func _body_exited(body):
	if body is Player:
		pick_up_hint.visible = false
		player_in_radius = null
