extends BaseState

## Weapon fire state — weapon is firing.
## Calls weapon._on_fire(), plays effect, then waits for animation to finish.

var _wait_timer: float = 0.0

func enter(_data: Dictionary = {}) -> void:
	var weapon = owner as WeaponBase
	if weapon == null:
		return

	# Notify weapon to do its fire logic (bullets, effects, etc.)
	if weapon.has_method("_on_fire"):
		weapon._on_fire()

	# Start cooldown so weapon can't fire again immediately
	weapon.start_cooldown()

	# Play fire animation
	if weapon.fire_effect:
		weapon.fire_effect.play("fire")
		# Connect to animation finished if not already
		if not weapon.fire_effect.animation_finished.is_connected(_on_anim_finished):
			weapon.fire_effect.animation_finished.connect(_on_anim_finished)

	_wait_timer = 0.0

func physics_update(delta: float) -> StringName:
	_wait_timer += delta
	var weapon = owner as WeaponBase
	# Wait for animation to finish (approx 0.28s for 7 frames at 25fps)
	if weapon and weapon.fire_effect and weapon.fire_effect.is_playing():
		return &""
	# Also fallback timer
	if _wait_timer > 0.3:
		return &"Idle"
	return &""

func exit() -> void:
	_wait_timer = 0.0
	var weapon = owner as WeaponBase
	if weapon and weapon.fire_effect:
		if weapon.fire_effect.animation_finished.is_connected(_on_anim_finished):
			weapon.fire_effect.animation_finished.disconnect(_on_anim_finished)

func _on_anim_finished() -> void:
	# Will be picked up by physics_update on next frame
	_wait_timer = 999.0
