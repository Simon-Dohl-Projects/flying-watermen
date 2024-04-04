extends Node2D

func _on_stone_tablet_read(reader):
	if reader.abilities:
		reader.abilities.building_foam = true

