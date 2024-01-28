extends Sprite2D

func _ready():
	material.set("shader_parameter/minStrength", randf_range(0.1, 0.4))
	material.set("shader_parameter/maxStrength", randf_range(0.5,0.7))
	material.set("shader_parameter/speed", randf_range(0.8,1.4))
	material.set("shader_parameter/heightOffset", 0.6)
