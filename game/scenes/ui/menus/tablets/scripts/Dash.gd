extends Node2D

func _on_stone_tablet_read(reader: Node2D) -> void:
	if reader.abilities:
		reader.abilities.dash = true
