extends Resource
class_name  PlayerData

@export var stored_health: int = 100
@export var stored_heat: int = 0
@export var stored_abilities: Dictionary = {
	"dash": false
	}
@export var stored_pos: Vector2

func set_storedhealth(value: int):
	stored_health = value

func set_storedheat(value: int):
	stored_heat = value

func set_storedabilities(value: Dictionary):
	stored_abilities = value

func update_pos(value: Vector2):
	stored_pos = value
