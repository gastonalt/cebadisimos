extends Camera2D

@export var min_zoom: float = 1
@export var max_zoom: float = 2.0
@export var zoom_factor: float = 300.0
@export var smoothness: float = 5.0

var jugadores: Array

func _ready() -> void:
	jugadores = get_tree().get_nodes_in_group("jugadores")

func _process(delta: float) -> void:
	if jugadores.size() < 2:
		return
	
	var p1 = jugadores[0].global_position
	var p2 = jugadores[1].global_position
	
	# 1. Punto medio
	var midpoint = (p1 + p2) / 2.0
	
	# 2. Distancia
	var distance = p1.distance_to(p2)
	
	# 3. Zoom deseado
	var target_zoom = clamp(zoom_factor / distance, min_zoom, max_zoom)
	
	# 4. Suavizado
	global_position = global_position.lerp(midpoint, delta * smoothness)
	zoom = zoom.lerp(Vector2(target_zoom, target_zoom), delta * smoothness)
