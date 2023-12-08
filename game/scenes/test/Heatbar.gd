extends TextureProgressBar

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	value = 0
	tint_progress.b = 0
	tint_progress.r = 255
	tint_progress.g = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	get_node("Heat_Lable").text = str(player.heat) + " / " + str(player.MAX_HEAT)

func setPlayer(object):
	player = object

func update():
	# updates heat
	value = player.heat * 100 / player.MAX_HEAT
