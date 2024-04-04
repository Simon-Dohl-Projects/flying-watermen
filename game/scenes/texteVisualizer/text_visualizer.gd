extends Control

@onready var label: Label = $Label
@onready var next_char: Timer = $nextChar

@export var message: String

var typing_speed = 0.01
var read_time = 2

var display = ""
var current_char = 0

func start_text():
	display = ""
	current_char = 0

	next_char.set_wait_time(typing_speed)
	next_char.start()

func _on_next_char_timeout():
	if (current_char < message.length()):
		var next_char = message[current_char]
		display += next_char
		label.text = display
		current_char += 1
	else:
		next_char.stop()

