extends TextureProgressBar

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	value = 100
	tint_progress.b = 255
	tint_progress.r = 0
	tint_progress.g = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	get_node("HEALTH_Lable").text = str(player.health) + " / " + str(player.MAX_HEALTH)

func setPlayer(object):
	player = object

func update():
	# updates health and heat
	value = player.health * 100 / player.MAX_HEALTH

