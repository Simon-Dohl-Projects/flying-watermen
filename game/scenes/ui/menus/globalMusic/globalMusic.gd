extends AudioStreamPlayer

@onready var global_music = preload("res://assets/SFX/worldMusic/Ambient5.ogg")

func play_music(music: AudioStream):
	if stream == music:
		return
	stream = music
	play()

func play_music_menu():
	play_music(global_music)

func stop_music_menu():
	stream = null
