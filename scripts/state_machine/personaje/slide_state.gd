extends BaseState

## Slide state — character sliding along the ground. (Future feature)

@onready var body_rig: Node2D = $"../../Body"

var slide_timer: float = 0.0
const SLIDE_DURATION: float = 0.35

func enter(_data: Dictionary = {}) -> void:
	body_rig.play("crouch")  # placeholder — will be "slide" when the anim is authored
	slide_timer = SLIDE_DURATION
	var ch = _get_character()
	ch.is_crouching = true
	# Give initial slide velocity
	ch.velocity.x = ch.direction * ch.SPEED * 1.2

func physics_update(delta: float) -> StringName:
	var ch = _get_character()

	if not ch.is_alive:
		return &"Death"

	slide_timer -= delta
	ch.velocity.x = move_toward(ch.velocity.x, 0, ch.DECELERATION * delta * 2.0)

	if slide_timer <= 0.0 or abs(ch.velocity.x) < 20:
		ch.is_crouching = false
		return &"Idle" if ch.is_on_floor() else &"Fall"

	if not ch.is_on_floor():
		ch.is_crouching = false
		return &"Fall"

	return &""

func exit() -> void:
	_get_character().is_crouching = false

func _get_character():
	return owner
