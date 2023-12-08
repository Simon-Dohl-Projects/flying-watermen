extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = DisplayServer.screen_get_size()
	var screen = DisplayServer.window_get_current_screen()
	DisplayServer.window_set_size(screen_size * 0.75)
	DisplayServer.window_set_position((screen_size * 0.25) / 2)
	DisplayServer.window_set_current_screen(screen)
	get_tree().change_scene_to_file("res://menus/title/title.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
