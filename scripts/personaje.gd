extends CharacterBody2D

## Main player character controller.
## Uses a node-based StateMachine for all movement states.
## Body and face are separate nodes for independent animation/overlay.

@onready var body_node: Node2D = $Body
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var state_machine: StateMachine = $StateMachine
@onready var right_hand: Marker2D = $RightHand
@onready var left_hand: Marker2D = $LeftHand

@export var player_id: int = 1

var direction: int = 1
var is_alive: bool = true
var is_crouching: bool = false
var is_invulnerable: bool = false
var _invuln_time: float = 0.0
var _squash_tween: Tween = null

const SPEED = 400.0
const CROUCH_SPEED = 160.0
const ACCELERATION = 2400.0
const DECELERATION = 2000.0
const JUMP_VELOCITY = -700.0
const SQUASH_ON_LAND = Vector2(1.25, 0.75)
const SQUASH_ON_JUMP = Vector2(0.8, 1.2)
const SPAWN_INVULN_TIME = 1.5

# Hitboxes — el fondo de la colisión queda en y=0 (nivel del piso)
# Vector4 = (ancho, alto, offset_x_centro, offset_y_centro)
const STAND_HITBOX = Vector4(16, 34, 0, -17)
const CROUCH_HITBOX = Vector4(20, 26, 0, -13)
const JUMP_HITBOX = Vector4(14, 28, 0, -14)
const FALL_HITBOX = Vector4(16, 32, 0, -16)
const DIE_HITBOX = Vector4(22, 18, 0, -9)

signal died(player_id: int)

func _ready() -> void:
	# Tintura del rig (color de jugador) y hitbox inicial
	body_node.set_tint(_get_player_color())
	body_node.anim_started.connect(_on_rig_anim_started)
	_apply_hitbox_for_anim(&"idle")
	# Spawn protection
	start_invulnerability(SPAWN_INVULN_TIME)

func start_invulnerability(duration: float) -> void:
	is_invulnerable = true
	_invuln_time = duration

func _tick_invulnerability(delta: float) -> void:
	if not is_invulnerable:
		return
	_invuln_time -= delta
	if _invuln_time <= 0.0:
		is_invulnerable = false
		body_node.modulate.a = 1.0
	else:
		body_node.modulate.a = 0.45 + 0.55 * absf(sin(_invuln_time * 20.0))

func _physics_process(delta: float) -> void:
	_tick_invulnerability(delta)
	if not is_alive:
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _on_rig_anim_started(anim: StringName) -> void:
	_apply_hitbox_for_anim(anim)

func _apply_hitbox_for_anim(anim: StringName) -> void:
	match anim:
		&"jump":
			_set_hitbox(JUMP_HITBOX)
		&"fall":
			_set_hitbox(FALL_HITBOX)
		&"crouch":
			_set_hitbox(CROUCH_HITBOX)
		&"die":
			_set_hitbox(DIE_HITBOX)
		_:
			_set_hitbox(STAND_HITBOX)

func _set_hitbox(data: Vector4) -> void:
	var w = data.x
	var h = data.y
	var cx = data.z
	var cy = data.w
	collision.shape = collision.shape.duplicate() if collision.shape else RectangleShape2D.new()
	if collision.shape is RectangleShape2D:
		collision.shape.size = Vector2(w, h)
		collision.position = Vector2(cx, cy)

func _get_facing_sign() -> float:
	var sx = signf(body_node.scale.x)
	if sx == 0.0:
		sx = signf(float(direction))
	return sx if sx != 0.0 else 1.0

func squash(target_scale: Vector2) -> void:
	if _squash_tween and _squash_tween.is_valid():
		_squash_tween.kill()
	var sx = _get_facing_sign()
	target_scale.x *= sx
	_squash_tween = create_tween()
	_squash_tween.tween_property(body_node, "scale", target_scale, 0.08)
	_squash_tween.tween_property(body_node, "scale", Vector2(sx, 1.0), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_weapon_fired() -> void:
	if _squash_tween and _squash_tween.is_valid():
		_squash_tween.kill()
	var sx = _get_facing_sign()
	_squash_tween = create_tween()
	_squash_tween.tween_property(body_node, "scale", Vector2(0.82 * sx, 1.18), 0.04)
	_squash_tween.tween_property(body_node, "scale", Vector2(sx, 1.0), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func take_damage(_amount: int, attacker_id: int) -> void:
	if not is_alive or is_invulnerable:
		return
	velocity.y = -200
	var attacker_pos = Vector2.ZERO
	var vivos = get_tree().get_nodes_in_group("jugadores")
	for j in vivos:
		if j.player_id == attacker_id:
			attacker_pos = j.global_position
			break
	var kb_dir = (global_position - attacker_pos).normalized()
	if kb_dir == Vector2.ZERO:
		kb_dir = Vector2.RIGHT
	velocity.x = kb_dir.x * 200
	EffectsManager.spawn_hit_particles(global_position, Color.WHITE)
	EffectsManager.shake(3.0, 0.1)
	_play_hit_flash()
	die()

func _play_hit_flash() -> void:
	body_node.modulate = Color(10, 10, 10)
	var tween = create_tween()
	tween.tween_property(body_node, "modulate", Color.WHITE, 0.15)

func _get_player_color() -> Color:
	return GlobalPlayerInfo.jugadores[player_id - 1].get_color()

func die() -> void:
	if not is_alive:
		return
	is_alive = false
	is_invulnerable = false
	body_node.modulate.a = 1.0
	died.emit(player_id)
	GlobalPlayerInfo.jugadores[player_id - 1].is_dead = true
	GameManager.on_player_died(player_id)
	state_machine.transition_to(&"Death")

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	await get_tree().create_timer(0.5).timeout
	die()
