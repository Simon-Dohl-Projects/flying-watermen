extends Node2D

@onready var camera = get_parent().get_parent().get_parent().get_node("Player/Camera2D")
@onready var pan = get_parent().get_parent().get_parent().get_node("Player/Camera2D/AnimationPlayer")

func _on_stone_tablet_read(reader: Node2D) -> void:
	pan.play("camera_pan")


