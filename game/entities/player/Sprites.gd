extends Node2D

func ice() -> void:
	$Ice.visible = true
	$Default.visible = false

func water() -> void:
	$Ice.visible = false
	$Default.visible = true
