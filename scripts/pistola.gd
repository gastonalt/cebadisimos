extends Node2D

@onready var anim = $disparo_animation
@export var player_id: int = 1

var disparando := false
var bullet_scene: PackedScene = preload("res://scenes/bala.tscn")

func _process(delta: float) -> void:
	var prefix = "p%d_" % player_id
	if Input.is_action_just_pressed(prefix + "shoot"):
		_disparar()

func _disparar() -> void:
	var bala = bullet_scene.instantiate()
	bala.global_position = global_position  # donde está el arma
	bala.rotation = rotation                # hacia donde apunta el arma/jugador
	bala.get_node("bala").player_id = player_id              # para que no se mate a sí mismo
	get_tree().current_scene.add_child(bala)

	anim.play("shooting_escopeta")
