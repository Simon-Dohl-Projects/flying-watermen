extends Control

var is_paused: bool = false:
	set = set_paused

func _ready():
	visible = false

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		is_paused = !is_paused

func set_paused(is_value: bool) -> void:
	is_paused = is_value
	get_tree().paused = is_paused
	visible = is_paused

func _on_resume_button_pressed():
	is_paused = false

func _on_return_to_menu_button_pressed():
	is_paused = false
	get_tree().change_scene_to_file.call_deferred(Globals.main_menu)

func _on_quit_game_button_pressed():
	get_tree().quit()
