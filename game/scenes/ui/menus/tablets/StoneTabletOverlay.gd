extends CanvasLayer

func _on_button_pressed():
	visible = false

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and visible:
		get_viewport().set_input_as_handled()
		visible = false

func pause():
	get_tree().paused = visible
