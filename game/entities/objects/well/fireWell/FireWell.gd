extends Area2D

@onready var sprite: Sprite2D = $Texture

var has_enemies_inside: Array[Object] = []
var new_well: PackedScene = load("res://entities/objects/well/normalWell/Well.tscn")
var already_filled: bool = false

func _ready() -> void:
	Globals.count_num_wells(position)
	Globals.fillwell.connect(fill_well_signal)
	$AudioStreamPlayer2D.play()

func _process(_delta):
	if has_enemies_inside == []:
		var well_instance: Interactable = new_well.instantiate()
		well_instance.global_position = position
		get_parent().add_child.call_deferred(well_instance)
		if already_filled:
			well_instance.fill_well(null, already_filled)
		queue_free()
	var index: int = 0
	for enemies in has_enemies_inside:
		if already_filled and enemies != null:
			enemies.queue_free()
		if str(enemies) == "<Freed Object>": has_enemies_inside.remove_at(index)
		index += 1
	index = 0

func _on_body_entered(body):
	if body is Player: $FillLabel.visible = true
	elif body is CharacterBody2D: has_enemies_inside.append(body)

func _on_body_exited(body):
	if body is Player:
		$FillLabel.visible = false

func fill_well_signal(pos: Vector2):
	if is_equal_approx(pos.x, position.x) and is_equal_approx(pos.y, position.y):
		already_filled = true
