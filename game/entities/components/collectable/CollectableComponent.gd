class_name Collectable extends Interactable

@export var item: Item

const COLLECT_DURATION: float = 0.03

func _ready():
	interact_hint = $PanelContainer
	interact_hint.visible = false

func collect(collector: Node):
	collector.inventory.set_item_in_inventory(item)
	var tween = create_tween()
	tween.tween_property(get_parent(), "position", collector.position, COLLECT_DURATION)
	tween.tween_property(get_parent(), "scale", Vector2.ZERO, COLLECT_DURATION)
	tween.finished.connect(get_parent().queue_free)
