extends WeaponBase

## Shotgun — area-based weapon with melee range.
## Uses the WeaponBase state machine for fire/reload.

@onready var area_impacto: Area2D = $AreaImpacto

var fire_texture: Texture2D = preload("res://sprites/All_Fire_Bullet_Pixel_16x16.png")

const RECOIL_KICK: float = 10.0
const TEXTURA_DEFAULT_X: float = 0.0

var _area_active: bool = false
var _area_timer: float = 0.0
const AREA_DURATION: float = 0.15

func _ready() -> void:
	weapon_name = "escopeta"
	area_impacto.scale = Vector2.ZERO
	super._ready()

func _process(delta: float) -> void:
	if _area_active:
		_area_timer -= delta
		area_impacto.scale = Vector2.ONE * (_area_timer / AREA_DURATION)
		if _area_timer <= 0.0:
			_area_active = false
			area_impacto.scale = Vector2.ZERO

func _on_fire() -> void:
	fired.emit()

	_area_active = true
	_area_timer = AREA_DURATION
	area_impacto.scale = Vector2.ONE

	# Effects
	EffectsManager.spawn_muzzle_smoke(muzzle_point.global_position, get_dir(), 8)
	EffectsManager.spawn_shell_casing(ejection_point.global_position, get_dir())
	EffectsManager.shake(8.0, 0.2)
	EffectsManager.hitlag(0.05)

	# Recoil
	_play_recoil()

	# Immediate area damage
	for body in area_impacto.get_overlapping_bodies():
		if body.is_in_group("jugadores") and body.player_id != player_id and body.is_alive and not body.is_invulnerable:
			EffectsManager.hitlag(0.05)
			body.die()

func _on_area_impacto_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores") and body.player_id != player_id and body.is_alive and not body.is_invulnerable and _area_active:
		EffectsManager.hitlag(0.05)
		body.die()

func _on_fire_effect_finished() -> void:
	fire_effect.stop()
	fire_effect.frame = 0

func _play_recoil() -> void:
	if weapon_sprite == null:
		return
	var tween = create_tween()
	tween.tween_property(weapon_sprite, "position:x", TEXTURA_DEFAULT_X - RECOIL_KICK, 0.04)
	tween.tween_property(weapon_sprite, "position:x", TEXTURA_DEFAULT_X - 3.0, 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(weapon_sprite, "position:x", TEXTURA_DEFAULT_X, 0.2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
