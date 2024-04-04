extends Interactable

signal read(reader: Node2D)

@onready var stone_tablet_content = get_parent().get_node("StoneTabletOverlay")

func _ready():
	interact_hint = %EKeyDark
	$AnimationPlayer.play("hover")
	Globals.stonetablet_remove.connect(load_stone_tablet)

func read_stone_tablet(reader: Node):
	stone_tablet_content.visible = true
	$CollisionShape2D/GPUParticles2D.visible = false
	read.emit(reader)
	Globals.stonetablet_read.emit(position)

func load_stone_tablet(pos: Vector2):
	if is_equal_approx(pos.x, position.x) and is_equal_approx(pos.y, position.y):
		$CollisionShape2D/GPUParticles2D.visible = false
