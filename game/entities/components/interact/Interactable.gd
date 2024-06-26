class_name Interactable extends Area2D

var interact_hint: Node = null
signal interacted(interactor: Node)

func enable_interact_hint():
	interact_hint.visible = true

func disable_interact_hint():
	interact_hint.visible = false

func interact(interactor: Node):
	interacted.emit(interactor)

func _ready() -> void:
	interact_hint.visible = false
