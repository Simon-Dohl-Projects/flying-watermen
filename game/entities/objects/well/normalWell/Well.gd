extends Interactable

@onready var sprite: Sprite2D = $Texture

const FULL_TEXTURE = preload("res://entities/objects/well/assets/wellFull.png")
const EMPTY_TEXTURE = preload("res://entities/objects/well/assets/wellEmpty.png")

var is_full: bool = false
var is_filled_load: bool = false
signal well_filled()

func _ready() -> void:
	interact_hint = $RichTextLabel
	if is_filled_load:
		delay_light()

## Fills the well, but only once
func fill_well(_body: Node, is_load: bool = false):
	is_filled_load = is_load
	if is_load:
		sprite = $Texture
	if not is_full:
		$CollisionShape2D.disabled = true
		sprite.texture = FULL_TEXTURE
		$GPUParticles2D.visible  = true
		well_filled.emit()
		is_full = true
		Globals.well_filled()
		if not is_filled_load:
			Globals.wellfilled.emit(position)
			delay_light()

# fix for the load
func delay_light():
	var tween = create_tween()
	tween.tween_property($PointLight2D, "energy", 1, 0.5)
