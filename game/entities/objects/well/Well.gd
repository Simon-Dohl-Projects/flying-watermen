extends Node2D

@onready var sprite: Sprite2D = $Texture
@onready var fill_label: Panel = $FillLabel

const FULL_TEXTURE = preload("res://entities/objects/well/assets/wellFull.png")
const EMPTY_TEXTURE = preload("res://entities/objects/well/assets/wellEmpty.png")

var is_full: bool = false
signal well_filled()

## Fills the well, but only once
func fill_well():
	if not is_full:
		sprite.texture = FULL_TEXTURE
		$GPUParticles2D.visible  = true
		well_filled.emit()
		is_full = true
		fill_label.visible = false

func _on_area_2d_body_entered(body):
	if body is Player:
		fill_label.visible = not is_full
		body.on_interact = fill_well

func _on_area_2d_body_exited(body: Node2D):
	if body is Player:
		body.on_interact = func(): print("Nothing to interact")
		fill_label.visible = false
