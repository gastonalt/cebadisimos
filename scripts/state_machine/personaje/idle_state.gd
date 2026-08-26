extends BaseState

## Idle state — character standing still.

@onready var body_rig: Node2D = $"../../Body"

func enter(_data: Dictionary = {}) -> void:
	body_rig.play("idle")

func physics_update(delta: float) -> StringName:
	var p = _get_prefix()
	var ch = _get_character()

	if not ch.is_alive:
		return &"Death"

	if not ch.is_on_floor():
		return &"Fall"

	if Input.is_action_pressed(p + "crouch"):
		return &"Crouch"

	if Input.is_action_just_pressed(p + "jump"):
		ch.velocity.y = ch.JUMP_VELOCITY
		ch.squash(ch.SQUASH_ON_JUMP)
		return &"Jump"

	var dir = Input.get_axis(p + "left", p + "right")
	if dir != 0:
		return &"Walk"

	ch.velocity.x = move_toward(ch.velocity.x, 0, ch.DECELERATION * delta)
	return &""

func _get_prefix() -> String:
	return "p%d_" % _get_character().player_id

func _get_character():
	return owner
