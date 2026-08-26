extends WeaponBase

## Pistol — ranged weapon that fires bullets.
## Uses the WeaponBase state machine for fire/reload.

var bullet_scene: PackedScene = preload("res://scenes/bala.tscn")
var fire_texture: Texture2D = preload("res://sprites/All_Fire_Bullet_Pixel_16x16.png")

const RECOIL_KICK: float = 6.0
const TEXTURA_DEFAULT_X: float = 0.0

func _ready() -> void:
	weapon_name = "pistola"
	super._ready()

func _on_fire() -> void:
	# Squash del personaje sincronizado con el disparo
	fired.emit() 

	# Spawn bullet
	var bala = bullet_scene.instantiate()
	bala.get_node("bala").setup(player_id, get_fire_dir())
	get_tree().current_scene.add_child(bala)
	bala.global_position = muzzle_point.global_position

	# Effects
	EffectsManager.spawn_muzzle_smoke(muzzle_point.global_position, get_dir(), 5)
	EffectsManager.spawn_shell_casing(ejection_point.global_position, get_dir())
	EffectsManager.shake(4.0, 0.1)

	# Recoil animation
	_play_recoil()

func _on_fire_effect_finished() -> void:
	fire_effect.stop()
	fire_effect.frame = 0

func _play_recoil() -> void:
	if weapon_sprite == null:
		return
	var tween = create_tween()
	tween.tween_property(weapon_sprite, "position:x", TEXTURA_DEFAULT_X - RECOIL_KICK, 0.03)
	tween.tween_property(weapon_sprite, "position:x", TEXTURA_DEFAULT_X, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
