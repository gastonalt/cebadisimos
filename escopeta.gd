extends Node2D

@onready var area = $areaImpacto
@onready var anim = $disparo_animation
@export var player_id: int = 1

var disparando := false
var velocidad_crecimiento := 5.0
var max_scale := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.scale = Vector2.ZERO
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var prefix = "p%d_" % player_id
	if Input.is_action_just_pressed(prefix + "shoot") and not disparando:
		disparando = true
		area.scale = Vector2(max_scale, max_scale)
		anim.play("shooting_escopeta")
		
		for body in area.get_overlapping_bodies():
			if body.is_in_group("jugadores") and body.player_id != player_id:
				body.queue_free()
		
	if disparando:
		area.scale += Vector2.ONE * (-velocidad_crecimiento) * delta
		
		if area.scale.x <= 0:
			disparando = false
			area.scale = Vector2.ZERO

func _on_disparo_animation_animation_finished() -> void:
	anim.stop()

func _on_area_impacto_body_entered(body: Node2D) -> void:
	if body.player_id != player_id and disparando:
		body.queue_free()
