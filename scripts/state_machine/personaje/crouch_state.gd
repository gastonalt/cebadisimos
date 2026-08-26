extends BaseState

## Crouch state — character crouching.

@onready var body_rig: Node2D = $"../../Body"

func enter(_data: Dictionary = {}) -> void:
	body_rig.play("crouch")
	_get_character().is_crouching = true

func physics_update(delta: float) -> StringName:
	var p = _get_prefix()
	var ch = _get_character()

	if not ch.is_alive:
		return &"Death"

	if not ch.is_on_floor():
		ch.is_crouching = false
		return &"Fall"

	if not Input.is_action_pressed(p + "crouch"):
		ch.is_crouching = false
		return &"Idle"

	ch.velocity.x = move_toward(ch.velocity.x, 0, ch.DECELERATION * delta)
	return &""

func exit() -> void:
	_get_character().is_crouching = false

func _get_prefix() -> String:
	return "p%d_" % _get_character().player_id

func _get_character():
	return owner
