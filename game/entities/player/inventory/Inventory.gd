class_name Inventory extends Node2D

var item_in_inventory: Item = null
var active_item: Item = null
var active_item_left: int = 0

signal on_item_in_inventory_updated(new_item: Item, old_item: Item)
signal on_item_activated(item: Item)
signal on_item_used(amount_left: int, max_amount: int)

func set_item_in_inventory(item: Item):
	on_item_in_inventory_updated.emit(item, item_in_inventory)
	item_in_inventory = item

func set_active_item(item: Item):
	if item:
		active_item_left = item.max_amount
	else:
		active_item_left = 0
		on_item_used.emit(active_item_left, 0)
	active_item = item
	on_item_activated.emit(item)

func use_active_item(amount: int):
	if active_item:
		active_item_left = maxi(active_item_left - amount, 0)
		on_item_used.emit(active_item_left, active_item.max_amount)
		if active_item_left == 0:
			set_active_item(null)

func _input(event):
	if event.is_action_pressed("activate_item") and item_in_inventory:
		set_active_item(item_in_inventory)
		set_item_in_inventory(null)
