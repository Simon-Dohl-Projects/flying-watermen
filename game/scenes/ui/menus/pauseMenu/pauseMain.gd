extends Control

signal resume_pressed
signal options_pressed
signal menu_pressed
signal quit_pressed

func _ready() -> void:
	visible = true

func _on_resume_pressed() -> void:
	resume_pressed.emit()

func _on_options_pressed() -> void:
	options_pressed.emit()

func _on_menu_pressed() -> void:
	menu_pressed.emit()

func _on_quit_pressed() -> void:
	quit_pressed.emit()

func _input(event: InputEvent) -> void:
	if is_visible_in_tree() and event.is_action_pressed("esc"):
		resume_pressed.emit()
		get_viewport().set_input_as_handled()
