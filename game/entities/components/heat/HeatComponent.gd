class_name HeatComponent extends Node2D

@export var health_component: HealthComponent
@export var heat_reduction_delay: Timer
@export var heat_tick: Timer
## Optional to display heat. Automatically assigned for Player
@export var _heat_bar: TextureProgressBar

const MAX_HEAT: int = 100
const HEAT_DAMAGE_THRESHOLD: int = 90
const HEAT_DAMAGE_PER_TICK: int = 1
const HEAT_REDUCTION_PER_TICK: int = 10

var heat: int = 0

signal heat_changed(new_heat: int, delta_heat: int)

func _ready():
	heat = 0
	if get_parent() is Player:
		_heat_bar = get_tree().get_first_node_in_group("playerHealthHeatBar")
		if not _heat_bar: print_debug("Player Heatbar not found")
	if _heat_bar: _heat_bar.tint_progress = Color("blue")
	heat_tick.timeout.connect(_on_heat_tick)

func _process(_delta: float):
	if _heat_bar:
		_heat_bar.tint_progress = Color("blue").lerp(Color("red"), heat / float(MAX_HEAT))

func increase_heat(amount: int):
	heat = mini(heat + amount, MAX_HEAT)
	heat_changed.emit(heat, amount)
	heat_reduction_delay.start()

func _on_heat_tick():
	if heat >= HEAT_DAMAGE_THRESHOLD:
		health_component.take_damage_no_iframes(HEAT_DAMAGE_PER_TICK, Element.Type.Fire)
	if heat_reduction_delay.is_stopped():
		heat = maxi(heat - HEAT_REDUCTION_PER_TICK, 0)
