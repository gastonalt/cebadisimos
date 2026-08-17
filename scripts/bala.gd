extends Area2D

@export var speed: float = 600.0
var player_id: int
var direccion: int = 0
var _trail_timer: float = 0.0
var _direction_set: bool = false

func _ready():
	await get_tree().process_frame
	var jugadores = get_tree().get_nodes_in_group("jugadores")
	for j in jugadores:
		if j.player_id == player_id:
			if j.direction == -1:
				direccion = -1
			else:
				direccion = 1
			break
	if direccion == 0:
		direccion = 1
	_direction_set = true

func _physics_process(delta: float) -> void:
	if not _direction_set:
		return
	position.x += direccion * speed * delta

	_trail_timer += delta
	if _trail_timer >= 0.03:
		_trail_timer = 0.0
		EffectsManager.spawn_bullet_trail(global_position)

	var cam = get_viewport().get_camera_2d()
	if cam:
		var cam_rect = Rect2(cam.global_position - Vector2(800, 500), Vector2(1600, 1000))
		if not cam_rect.has_point(global_position):
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not _direction_set:
		return
	if body.is_in_group("jugadores") and body.player_id != player_id and body.is_alive:
		EffectsManager.hitlag(0.03)
		body.die()
		queue_free()
	elif not body.is_in_group("jugadores"):
		EffectsManager.spawn_hit_particles(global_position, Color(0.5, 0.5, 0.5))
		queue_free()
