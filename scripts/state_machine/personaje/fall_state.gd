extends BaseState

## Fall state — character falling down.

@onready var body_rig: Node2D = $"../../Body"

func enter(_data: Dictionary = {}) -> void:
	body_rig.play("jump")  # reuse jump pose for falling

func physics_update(delta: float) -> StringName:
	var p = _get_prefix()
	var ch = _get_character()

	if not ch.is_alive:
		return &"Death"

	# Air control
	var dir = Input.get_axis(p + "left", p + "right")
	if dir != 0:
		ch.direction = dir
		ch.body_node.scale.x = dir
		ch.right_hand.scale.x = dir
		ch.left_hand.scale.x = dir
		ch.velocity.x = move_toward(ch.velocity.x, dir * ch.SPEED, ch.ACCELERATION * delta * 0.7)
	else:
		ch.velocity.x = move_toward(ch.velocity.x, 0, ch.DECELERATION * delta * 0.5)

	# Landed
	if ch.is_on_floor():
		ch.squash(ch.SQUASH_ON_LAND)
		EffectsManager.spawn_landing_dust(ch.global_position)
		return &"Idle"

	return &""

func _get_prefix() -> String:
	return "p%d_" % _get_character().player_id

func _get_character():
	return owner
