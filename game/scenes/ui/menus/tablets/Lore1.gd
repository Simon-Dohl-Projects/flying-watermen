extends Node2D

var sequence: PackedScene = load("res://scenes/ui/menus/tablets/sequence.tscn")
var scene: CanvasLayer

func _on_stone_tablet_overlay_visibility_changed() -> void:
	if $StoneTabletOverlay.visible == true:
		scene = sequence.instantiate()
		add_child.call_deferred(scene)
	elif scene != null: scene.queue_free()
