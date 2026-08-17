extends Node

var _camera: Camera2D = null
var _shake_tween: Tween = null

func register_camera(cam: Camera2D) -> void:
	_camera = cam

func shake(intensity: float, duration: float) -> void:
	if _camera == null:
		return
	if _shake_tween and _shake_tween.is_valid():
		_shake_tween.kill()
	_shake_tween = create_tween()
	var steps = int(duration / 0.016)
	for i in range(steps):
		var t = float(i) / float(steps)
		var current_intensity = intensity * (1.0 - t)
		_shake_tween.tween_method(_apply_shake.bind(current_intensity), 0.0, 1.0, 0.016)
	_shake_tween.tween_callback(_end_shake)

func _apply_shake(_val: float, current_intensity: float) -> void:
	_camera.offset = Vector2(
		randf_range(-current_intensity, current_intensity),
		randf_range(-current_intensity, current_intensity)
	)

func _end_shake() -> void:
	if _camera:
		_camera.offset = Vector2.ZERO

func spawn_hit_particles(pos: Vector2, color: Color = Color.WHITE) -> void:
	var particles = CPUParticles2D.new()
	particles.emitting = true
	particles.one_shot = true
	particles.amount = 8
	particles.lifetime = 0.3
	particles.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	particles.spread = 45.0
	particles.initial_velocity_min = 80.0
	particles.initial_velocity_max = 150.0
	particles.gravity = Vector2(0, 200)
	particles.scale_amount_min = 1.0
	particles.scale_amount_max = 2.0
	particles.color = color
	particles.global_position = pos
	get_tree().current_scene.add_child(particles)
	await get_tree().create_timer(0.5).timeout
	if is_instance_valid(particles):
		particles.queue_free()

func spawn_death_particles(pos: Vector2, color: Color = Color(0.4, 0.7, 0.2)) -> void:
	var particles = CPUParticles2D.new()
	particles.emitting = true
	particles.one_shot = true
	particles.amount = 20
	particles.lifetime = 0.6
	particles.direction = Vector2(0, -1)
	particles.spread = 180.0
	particles.initial_velocity_min = 100.0
	particles.initial_velocity_max = 250.0
	particles.gravity = Vector2(0, 400)
	particles.scale_amount_min = 1.5
	particles.scale_amount_max = 3.0
	particles.color = color
	particles.global_position = pos
	get_tree().current_scene.add_child(particles)
	await get_tree().create_timer(0.8).timeout
	if is_instance_valid(particles):
		particles.queue_free()

func spawn_bullet_trail(pos: Vector2) -> void:
	var dot = ColorRect.new()
	dot.color = Color(1, 0.8, 0.3, 0.6)
	dot.size = Vector2(3, 2)
	dot.global_position = pos + Vector2(-1, -1)
	get_tree().current_scene.add_child(dot)
	var tween = dot.create_tween()
	tween.tween_property(dot, "modulate:a", 0.0, 0.12)
	tween.tween_callback(dot.queue_free)

func spawn_muzzle_smoke(pos: Vector2, direction: int = 1, count: int = 4) -> void:
	var particles: Array[CPUParticles2D] = []
	for i in range(count):
		var smoke = CPUParticles2D.new()
		smoke.emitting = true
		smoke.one_shot = true
		smoke.amount = 1
		smoke.lifetime = 0.5
		smoke.direction = Vector2(direction * randf_range(30, 80), randf_range(-60, -100))
		smoke.spread = 30.0
		smoke.initial_velocity_min = 40.0
		smoke.initial_velocity_max = 80.0
		smoke.gravity = Vector2(0, -30)
		smoke.scale_amount_min = 1.0
		smoke.scale_amount_max = 2.5
		smoke.color = Color(0.85, 0.85, 0.85, 0.7)
		smoke.global_position = pos + Vector2(randf_range(-3, 3), randf_range(-3, 3))
		get_tree().current_scene.add_child(smoke)
		particles.append(smoke)
	await get_tree().create_timer(0.7).timeout
	for p in particles:
		if is_instance_valid(p):
			p.queue_free()

func spawn_shell_casing(pos: Vector2, direction: int = 1) -> void:
	var casing = ColorRect.new()
	casing.color = Color(0.9, 0.7, 0.2)
	casing.size = Vector2(5, 3)
	casing.global_position = pos
	get_tree().current_scene.add_child(casing)

	var target_x = pos.x + direction * randf_range(50, 90)
	var target_y = pos.y + randf_range(30, 50)
	var tween = casing.create_tween()
	tween.set_parallel(true)
	tween.tween_property(casing, "position:x", target_x, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(casing, "position:y", target_y, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.chain().tween_property(casing, "position:y", target_y + 40, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

	var rot_tween = casing.create_tween()
	rot_tween.tween_property(casing, "rotation", randf_range(3.0, 7.0), 0.4)

	await get_tree().create_timer(0.6).timeout
	if is_instance_valid(casing):
		casing.queue_free()

func hitlag(duration: float = 0.03) -> void:
	get_tree().paused = true
	await get_tree().create_timer(duration, true, false, true).timeout
	get_tree().paused = false

func spawn_landing_dust(pos: Vector2) -> void:
	var dust = CPUParticles2D.new()
	dust.emitting = true
	dust.one_shot = true
	dust.amount = 6
	dust.lifetime = 0.3
	dust.direction = Vector2(0, -1)
	dust.spread = 90.0
	dust.initial_velocity_min = 20.0
	dust.initial_velocity_max = 50.0
	dust.gravity = Vector2(0, 100)
	dust.scale_amount_min = 1.0
	dust.scale_amount_max = 2.0
	dust.color = Color(0.75, 0.65, 0.5, 0.6)
	dust.global_position = pos + Vector2(0, 4)
	get_tree().current_scene.add_child(dust)
	await get_tree().create_timer(0.5).timeout
	if is_instance_valid(dust):
		dust.queue_free()

func spawn_slide_sparks(pos: Vector2, direction: int = 1) -> void:
	var sparks = CPUParticles2D.new()
	sparks.emitting = true
	sparks.one_shot = true
	sparks.amount = 4
	sparks.lifetime = 0.2
	sparks.direction = Vector2(-direction, -1)
	sparks.spread = 40.0
	sparks.initial_velocity_min = 60.0
	sparks.initial_velocity_max = 120.0
	sparks.gravity = Vector2(0, 300)
	sparks.scale_amount_min = 0.5
	sparks.scale_amount_max = 1.5
	sparks.color = Color(1.0, 0.8, 0.3)
	sparks.global_position = pos
	get_tree().current_scene.add_child(sparks)
	await get_tree().create_timer(0.4).timeout
	if is_instance_valid(sparks):
		sparks.queue_free()
