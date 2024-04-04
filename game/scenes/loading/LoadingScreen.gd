class_name LoadingScreen extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var animation: AnimatedSprite2D = %Distraction

var progress: Array = []
var scene_to_load: String = ""
var load_status: float = 0
var highest_progress: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if scene_to_load:
		ResourceLoader.load_threaded_request(scene_to_load, "", true)
	animation.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not scene_to_load: return
	load_status = ResourceLoader.load_threaded_get_status(scene_to_load, progress)
	highest_progress = max(floor(progress[0]*100), highest_progress)
	progress_bar.value = highest_progress
	texture_progress_bar.value = highest_progress
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_to_load))
		queue_free()
