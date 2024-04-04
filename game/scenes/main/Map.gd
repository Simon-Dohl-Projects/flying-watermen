extends Node2D

func _on_destroyable_wall_3_wall_destroyed():
	$WindTunnels/WindTunnel3/CollisionShape2D.set_deferred("disabled", false)
	$WindTunnels/WindTunnel3.visible = true

func _on_audio_stream_player_finished():
	$Environment/AudioStreamPlayer.play()

func _on_world_music_of_body_entered(body):
	if body is Player:
		$Environment/AudioStreamPlayer.volume_db = -1000

func _on_world_music_on_body_entered(body):
	if body is Player:
		$Environment/AudioStreamPlayer.volume_db = 0
