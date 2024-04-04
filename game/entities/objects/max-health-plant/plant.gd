extends Interactable

var health_gained: int = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	interact_hint = $E_key_dark
	Globals.plantdelete.connect(delete_plant)

func _on_interacted(interactor):
	var health_component = interactor.get_node_or_null("HealthComponent")
	PolyphonicAudioPlayer.play_sound_effect_from_library("max_health")
	health_component.max_health += health_gained
	health_component.heal(health_gained)
	Globals.planteaten.emit(position)
	queue_free()

func delete_plant(pos: Vector2):
	if is_equal_approx(pos.x, position.x) and is_equal_approx(pos.y, position.y):
		queue_free()
