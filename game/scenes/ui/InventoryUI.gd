extends Control

@onready var inventory_text: RichTextLabel = $InventoryItem
@onready var active_item: Control = $ActiveItem
@onready var active_item_name: RichTextLabel = $ActiveItem/Name
@onready var active_item_amount: RichTextLabel = $ActiveItem/Amount
@onready var active_item_meter: ProgressBar = $ActiveItem/ItemBar
@onready var use_item_text: RichTextLabel = $"Use _F_"
@onready var inventory: Inventory = get_tree().get_first_node_in_group("player").inventory

func _ready():
	inventory.on_item_in_inventory_updated.connect(update_item_in_inventory)
	inventory.on_item_activated.connect(update_active_item)
	inventory.on_item_used.connect(update_item_bar)
	update_item_in_inventory(inventory.item_in_inventory, null)
	update_item_bar(inventory.active_item_left, inventory.active_item_left)
	update_active_item(inventory.active_item)

func update_item_in_inventory(new_item: Item, _old_item: Item):
	if new_item:
		inventory_text.text = new_item.name
		use_item_text.text = "Use 'F'"
	else:
		inventory_text.text = "no item in inventory"
		use_item_text.text = ""

func update_active_item(item: Item):
	active_item_name.visible = item != null
	if item:
		active_item_name.text = item.name
		update_item_bar(item.max_amount, item.max_amount)

func update_item_bar(amount: int, max_amount: int):
	active_item.visible = amount > 0
	active_item_amount.text = str(amount)+"/"+str(max_amount)
	active_item_meter.value = (amount / float(max_amount)) * 100
