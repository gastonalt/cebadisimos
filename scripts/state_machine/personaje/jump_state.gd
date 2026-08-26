extends BaseState

## Jump state — character ascending.

@onready var body_rig: Node2D = $"../../Body"

func enter(_data: Dictionary = {}) -> void:
	body_rig.play("jump")

func physics_update(delta: float) -> StringName:
	var p = _get_prefix()
	var ch = _get_character()

	if not ch.is_alive:
		return &"Death"

	# Allow horizontal movement in air
	var dir = Input.get_axis(p + "left", p + "right")
	if dir != 0:
		ch.direction = dir
		ch.body_node.scale.x = dir
		ch.right_hand.scale.x = dir
		ch.left_hand.scale.x = dir
		ch.velocity.x = move_toward(ch.velocity.x, dir * ch.SPEED, ch.ACCELERATION * delta * 0.7)
	else:
		ch.velocity.x = move_toward(ch.velocity.x, 0, ch.DECELERATION * delta * 0.5)

	# Transition to fall when velocity.y becomes positive
	if ch.velocity.y > 0:
		return &"Fall"

	return &""

func _get_prefix() -> String:
	return "p%d_" % _get_character().player_id

func _get_character():
	return owner
