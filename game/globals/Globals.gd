extends Node

var main_scene = "res://scenes/main/Map.tscn"
var test_scene = "res://scenes/test/test.tscn"
var game_over = "res://scenes/ui/menus/gameOver/GameOver.tscn"
var main_menu = "res://scenes/ui/menus/menu/menu.tscn"
var win_screen = "res://scenes/ui/menus/winscreen/winscreen.tscn"
var save_file_path: String = "user://save/"
var save_file_name: String = "PlayerSave.tres"
var is_boos_alive: bool = true
var wells_filled: int = 0
var num_wells: int = 0
var wells_location: Dictionary = {}
signal wellfilled(pos: Vector2)
signal fillwell(pos: Vector2)
signal planteaten(pos: Vector2)
signal plantdelete(pos: Vector2)
signal stonetablet_read(pos: Vector2)
signal stonetablet_remove(pos: Vector2)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("str+1"):
		load_with_loading_screen(main_scene)
	if event.is_action_pressed("str+2"):
		load_with_loading_screen(test_scene)
	if event.is_action_pressed("str+r"):
		get_tree().reload_current_scene()

func load_with_loading_screen(scene_name: String):
	var loading_screen: LoadingScreen = load("res://scenes/loading/LoadingScreen.tscn").instantiate()
	loading_screen.scene_to_load = scene_name
	get_tree().root.get_children().back().queue_free()
	get_tree().root.add_child(loading_screen)

func count_num_wells(value: Vector2):
	if not wells_location.has(value):
		wells_location[value] = value
		num_wells = num_wells + 1

func well_filled():
	wells_filled = wells_filled + 1
	check_win_con()

func boss_killed():
	is_boos_alive = false
	check_win_con()

func check_win_con():
	if not is_boos_alive and wells_filled == num_wells:
		get_tree().change_scene_to_file.call_deferred(win_screen)

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func delet_save():
	verify_save_directory(save_file_path)
	if FileAccess.file_exists(save_file_path + save_file_name):
		DirAccess.remove_absolute(save_file_path + save_file_name)
