extends TextureProgressBar

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var health_label: Label = %HP

const COLD: Color = Color("blue")
const HOT: Color = Color("red")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.health_component.health_changed.connect(on_player_health_changed)
	player.health_component.max_health_changed.connect(update_max_health)
	update_max_health(player.health_component.max_health)
	on_player_health_changed(player.health_component.health, player.health_component.max_health)
	value = player.health_component.max_health

func on_player_health_changed(new_health: int, _delta_health: int):
	@warning_ignore("integer_division")
	value = new_health * player.health_component.max_health / player.health_component.max_health
	health_label.text = str(new_health) + " / " + str(player.health_component.max_health)

func _process(_delta):
	if player:
		var heat_component: HeatComponent = player.heat_component
		tint_progress = COLD.lerp(HOT, heat_component.heat / float(heat_component.MAX_HEAT))

func update_max_health(new: int):
	max_value = new
	custom_minimum_size = Vector2(new, custom_minimum_size.y)
