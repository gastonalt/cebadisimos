class_name WeaponBase extends Node2D

## Base class for ALL weapons. Attach as child of a hand Marker2D.
## The weapon defines its own reference points (muzzle, grips, ejection).
## On _ready, it aligns itself so RightGripPoint matches the parent hand position.

@export var stats: WeaponStats = null

@onready var weapon_sprite: Sprite2D = $WeaponSprite
@onready var muzzle_point: Marker2D = $MuzzlePoint
@onready var ejection_point: Marker2D = $EjectionPoint
@onready var right_grip: Marker2D = $RightGripPoint
@onready var left_grip: Marker2D = $LeftGripPoint
@onready var fire_effect: AnimatedSprite2D = $FireEffect
@onready var weapon_sm: StateMachine = $StateMachine

## Set by the pickup system or parent. The CharacterBody2D in "jugadores" group.
var weapon_owner = null
var player_id: int = 1
var weapon_name: String = ""
var can_fire: bool = true
var current_ammo: int = -1

signal fired
signal reloaded
signal cooldown_started
signal cooldown_ended

func _ready() -> void:
	if stats == null:
		stats = WeaponStats.new()
		current_ammo = stats.ammo
	# Find owner by traversing up
	weapon_owner = _find_owner()
	if weapon_owner:
		player_id = weapon_owner.player_id
	# Align weapon so RightGripPoint matches parent (hand) position
	_align_to_hand()
	# Connect to character's weapon_fired signal for squash
	if weapon_owner and weapon_owner.has_method("_on_weapon_fired"):
		fired.connect(weapon_owner._on_weapon_fired)

func _find_owner():
	var node = get_parent()
	while node:
		if node.is_in_group("jugadores"):
			return node
		node = node.get_parent()
	return null

func _align_to_hand() -> void:
	# The weapon is a child of a hand Marker2D.
	# We offset so that RightGripPoint is at (0,0) of the parent.
	if right_grip:
		position = -right_grip.position

func can_use() -> bool:
	return can_fire and (current_ammo < 0 or current_ammo > 0)

func consume_ammo() -> void:
	if current_ammo > 0:
		current_ammo -= 1
	if current_ammo <= 0 and stats.max_ammo > 0:
		# Out of ammo — trigger reload
		if weapon_sm:
			weapon_sm.transition_to(&"Reload")

func start_cooldown() -> void:
	if not can_fire:
		return
	can_fire = false
	cooldown_started.emit()
	await get_tree().create_timer(stats.cooldown_time).timeout
	can_fire = true
	cooldown_ended.emit()

func get_dir() -> int:
	return 1 if global_scale.x >= 0 else -1

func get_fire_dir() -> int:
	if weapon_owner != null and "direction" in weapon_owner:
		var d = signi(int(weapon_owner.direction))
		if d != 0:
			return d
	return get_dir()

func get_muzzle_global() -> Vector2:
	return muzzle_point.global_position

func get_ejection_global() -> Vector2:
	return ejection_point.global_position
