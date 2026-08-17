extends Camera2D

func _ready() -> void:
	EffectsManager.register_camera(self)
	make_current()
