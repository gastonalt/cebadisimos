extends BaseState

## Weapon idle state — waiting for fire input.

func physics_update(_delta: float) -> StringName:
	var weapon = owner as WeaponBase
	if weapon == null or weapon.weapon_owner == null:
		return &""

	var prefix = "p%d_" % weapon.player_id
	if Input.is_action_just_pressed(prefix + "shoot") and weapon.can_use():
		return &"Fire"

	return &""
