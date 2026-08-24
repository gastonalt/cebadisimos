extends WeaponBase

## Pistola 2 — arma animada con los 7 frames extraidos del gif.
## La animacion de fuego incluye el recoil horneado: este script solo
## lo acompana con un empujon fisico sutil y efectos.

const BULLET_SCENE := preload("res://scenes/bala.tscn")

const RECOIL_KICK: float = 2.0
const RECOIL_RETURN_TIME: float = 0.18

var _base_pos: Vector2
var _recoil_tween: Tween = null

func _ready() -> void:
	weapon_name = "pistola_2"
	super._ready()
	_base_pos = position

func _on_fire() -> void:
	# Squash del personaje sincronizado con el disparo
	fired.emit()

	# Balita desde el cañón, coordinada con el frame 0 del fogonazo
	var bala = BULLET_SCENE.instantiate()
	get_tree().current_scene.add_child(bala)
	bala.global_position = muzzle_point.global_position
	bala.get_node("bala").player_id = player_id

	# Efectos
	EffectsManager.spawn_muzzle_smoke(muzzle_point.global_position, get_dir(), 5)
	EffectsManager.spawn_shell_casing(ejection_point.global_position, get_dir())
	EffectsManager.shake(4.0, 0.1)

	# Swap visual: sprite estático OFF, animación completa ON
	if weapon_sprite:
		weapon_sprite.visible = false
	fire_effect.visible = true

	# Empujón físico sutil, sincronizado con el jolt del gif
	_play_recoil()

func _on_fire_effect_finished() -> void:
	fire_effect.stop()
	fire_effect.frame = 0
	fire_effect.visible = false
	if weapon_sprite:
		weapon_sprite.visible = true

func _play_recoil() -> void:
	if _recoil_tween and _recoil_tween.is_valid():
		_recoil_tween.kill()
	position = _base_pos
	_recoil_tween = create_tween()
	_recoil_tween.tween_property(self, "position:x", _base_pos.x - RECOIL_KICK, 0.04)
	_recoil_tween.tween_property(self, "position:x", _base_pos.x, RECOIL_RETURN_TIME).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
