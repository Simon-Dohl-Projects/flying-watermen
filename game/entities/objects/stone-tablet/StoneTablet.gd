extends Node2D

@onready var fill_label: Panel = $FillLabel
@onready var read_stone_tablet_scene = get_parent().get_node("ReadStoneTablet")

func _ready():
	$AnimationPlayer.play("hover")

func _on_area_2d_body_entered(body):
	if body is Player:
		fill_label.visible = true
		body.on_interact = read_stone_tablet

func _on_area_2d_body_exited(body):
	if body is Player:
		body.on_interact = func(): print("Nothing to interact")
		fill_label.visible = false

func read_stone_tablet():
	read_stone_tablet_scene.visible = true

func hide_stone_tablet():
	read_stone_tablet_scene.visible = false
