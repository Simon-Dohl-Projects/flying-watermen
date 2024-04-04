extends Button

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_mouse_entered():
	audio_stream_player.play()
