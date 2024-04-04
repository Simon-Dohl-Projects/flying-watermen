class_name Menu extends Control

@onready var main: MainMenu = %Main
@onready var option: OptionsMenu = %Options
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var music = preload("res://assets/SFX/worldMusic/Ambient5.ogg")

func _ready():
	audio_stream_player.stream = music
	audio_stream_player.play()

func _on_tree_exiting() -> void:
	audio_stream_player.stream = null

func _on_main_options_pressed() -> void:
	main.visible = false
	option.visible = true

func _on_options_back_pressed() -> void:
	main.visible = true
	option.visible = false
