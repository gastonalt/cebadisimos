extends Node2D

## Rig de personaje estilo paper-doll.
## Partes separadas (torso, brazos, piernas) animadas por un AnimationPlayer.
## Expone una API parecida a AnimatedSprite2D (play / speed_scale) para que
## la state machine no cambie su logica.

signal anim_started(anim: StringName)

@onready var _player: AnimationPlayer = $AnimationPlayer

var current_anim: StringName = &""

var speed_scale: float = 1.0:
	get:
		return _player.speed_scale
	set(value):
		_player.speed_scale = value

func _ready() -> void:
	# El estado inicial de la maquina no llama enter(), asi como el
	# AnimatedSprite2D viejo tenia autoplay, aca largamos idle.
	if _player.has_animation(&"idle"):
		current_anim = &"idle"
		_player.play(&"idle")

func play(anim: StringName) -> void:
	if current_anim == anim and _player.is_playing():
		return
	if not _player.has_animation(anim):
		push_warning("Rig: animacion '%s' inexistente" % anim)
		return
	current_anim = anim
	_player.play(anim)
	anim_started.emit(anim)

func stop() -> void:
	_player.stop()
	current_anim = &""

func set_tint(color: Color) -> void:
	for sprite in _find_sprites(self):
		sprite.self_modulate = color

func _find_sprites(node: Node) -> Array[Sprite2D]:
	var out: Array[Sprite2D] = []
	if node is Sprite2D:
		out.append(node)
	for child in node.get_children():
		out.append_array(_find_sprites(child))
	return out
