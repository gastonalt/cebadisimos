extends BaseState

## Walk state — character moving horizontally.

@onready var body_rig: Node2D = $"../../Body"

func enter(_data: Dictionary = {}) -> void:
	body_rig.play("walk")

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
	if dir == 0:
		return &"Idle"

	ch.direction = dir
	ch.body_node.scale.x = dir
	ch.right_hand.scale.x = dir
	ch.left_hand.scale.x = dir
	var speed = ch.CROUCH_SPEED if ch.is_crouching else ch.SPEED
	ch.velocity.x = move_toward(ch.velocity.x, dir * speed, ch.ACCELERATION * delta)
	# Animación adaptativa: camina más rápido -> anima más rápido
	body_rig.speed_scale = clampf(abs(ch.velocity.x) / float(speed), 0.6, 1.6)
	return &""

func exit() -> void:
	body_rig.speed_scale = 1.0

func _get_prefix() -> String:
	return "p%d_" % _get_character().player_id

func _get_character():
	return owner
