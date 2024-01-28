class_name EnemyManager extends Node2D

@onready var player: Player = get_tree().get_first_node_in_group("player")

@onready var enemy_spawn_probabilities: Dictionary = {
	"rangedEnemy": {
		"weight": 0.3,
		"scene": load("res://entities/enemies/rangedEnemy/RangedEnemy.tscn")
	},
	"meleeEnemy": {
		"weight": 0.7,
		"scene": load("res://entities/enemies/meleeEnemy/MeleeEnemy.tscn")
	},
}

#region Test
func test_enemy_probabilities():
	var total_probability: float = 0
	for key in enemy_spawn_probabilities:
		var enemy: Dictionary = enemy_spawn_probabilities[key]
		if not enemy["weight"]:
			push_warning("Weight missing in "+key)
			continue
		if not enemy["scene"]:
			push_warning("Scene missing in "+key)
			continue
		total_probability += enemy["weight"]
	if abs(total_probability-1) > 0.01:
		push_warning("Weights don't add up to 1 but " + str(total_probability))
#endregion

func _ready():
	test_enemy_probabilities()

func spawn_random_enemy(_position: Vector2):
	var random: float = randf()
	var current_prob: float = 0
	for key in enemy_spawn_probabilities:
		var enemy_type: Dictionary = enemy_spawn_probabilities[key]
		current_prob += enemy_type["weight"]
		if random < current_prob:
			var enemy_instance: CharacterBody2D = enemy_type["scene"].instantiate()
			enemy_instance.global_position = _position
			get_parent().add_child.call_deferred(enemy_instance)
			return
