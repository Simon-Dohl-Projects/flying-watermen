extends CanvasLayer

func _on_button_pressed():
	visible = false

func _ready() -> void:
	visible = false

func pause():
	get_tree().paused = visible
