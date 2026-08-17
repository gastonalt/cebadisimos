extends BaseState

## Weapon reload state — weapon is reloading.

var reload_timer: float = 0.0

func enter(_data: Dictionary = {}) -> void:
	var weapon = owner as WeaponBase
	if weapon == null:
		return
	reload_timer = weapon.stats.reload_time

func physics_update(delta: float) -> StringName:
	reload_timer -= delta
	if reload_timer <= 0.0:
		var weapon = owner as WeaponBase
		if weapon:
			weapon.current_ammo = weapon.stats.max_ammo
			weapon.reloaded.emit()
		return &"Idle"
	return &""
