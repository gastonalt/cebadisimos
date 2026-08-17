extends BaseState

## Death state — character is dead.

@onready var body_sprite: AnimatedSprite2D = $"../../Body/BodySprite"

func enter(_data: Dictionary = {}) -> void:
	body_sprite.play("die")
	var ch = _get_character()
	ch.velocity = Vector2.ZERO
	ch.collision.set_deferred("disabled", true)
	EffectsManager.spawn_death_particles(ch.global_position, ch._get_player_color())
	EffectsManager.shake(5.0, 0.25)

func physics_update(_delta: float) -> StringName:
	return &""

func _get_character():
	return owner
