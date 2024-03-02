extends Interactable

signal read(reader: Node2D)

@onready var read_stone_tablet_scene = get_parent().get_node("StoneTabletOverlay")

func _ready():
	interact_hint = %EKeyDark
	$AnimationPlayer.play("hover")

func read_stone_tablet(reader: Node):
	read_stone_tablet_scene.visible = true
	read.emit(reader)
