extends Area2D

@export var speed: float = 600.0
var player_id: int
var direccion

func _ready():
	if get_tree().get_nodes_in_group("jugadores")[player_id - 1].get_node("Sprite2D").flip_h:
		direccion = -1
	else:
		direccion = 1

func _physics_process(delta: float) -> void:
	position.x += direccion * speed * delta

	# Si se va de la pantalla → se borra
	if not get_viewport_rect().has_point(global_position):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.player_id != player_id:
		body.queue_free()
		queue_free()  # la bala despawnea al impactar
