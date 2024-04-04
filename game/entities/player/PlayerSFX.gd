extends Node

var item_in_inventory: String = ""

# jump sound
func _on_jumping_state_entered():
	PolyphonicAudioPlayer.play_sound_effect_from_library("jump")

#dash sound
func _on_dash_state_entered():
	PolyphonicAudioPlayer.play_sound_effect_from_library("dash")

# pick up sound
func _on_inventory_on_item_in_inventory_updated(new_item, _old_item):
	if !new_item == null:
		PolyphonicAudioPlayer.play_sound_effect_from_library("pickup_item")

# melee attack sound
func _on_melee_component_melee_attack_started():
	PolyphonicAudioPlayer.play_sound_effect_from_library("melee_player")

# determin which sound needs to be played for a specific item
func _on_ranged_component_projectile_shoot():
	if item_in_inventory == "foam":
		PolyphonicAudioPlayer.play_sound_effect_from_library("foam")
	if item_in_inventory == "sodium":
		PolyphonicAudioPlayer.play_sound_effect_from_library("sodium")
	else:
		PolyphonicAudioPlayer.play_sound_effect_from_library("shoot_player")

func _on_inventory_on_item_activated(item):
	if item == null:
		return
	if item.name == "ice":
		PolyphonicAudioPlayer.play_sound_effect_from_library("ice")
	else: item_in_inventory = item.name

func _on_inventory_on_item_used(amount_left, _max_amount):
	if amount_left == 0:
		item_in_inventory = ""
