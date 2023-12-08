extends CanvasLayer

@onready var debugger: Control = $StateChartDebugger

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_tree().get_first_node_in_group("player")
	debugger.debug_node(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("f3"):
		debugger.visible = !debugger.visible
