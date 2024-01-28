extends TextureProgressBar

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var health_label: Label = $"../Label"

const COLD: Color = Color("blue")
const HOT: Color = Color("red")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.health_component.health_changed.connect(_on_player_health_changed)
	_on_player_health_changed(player.health_component.health, player.health_component.max_health)
	value = 100

func _on_player_health_changed(new_health: int, _delta_health: int):
	@warning_ignore("integer_division")
	value = new_health * 100 / player.health_component.max_health
	health_label.text = str(new_health) + " / " + str(player.health_component.max_health)

func _process(_delta):
	if player:
		var heat_component: HeatComponent = player.heat_component
		tint_progress = COLD.lerp(HOT, heat_component.heat / float(heat_component.MAX_HEAT))
