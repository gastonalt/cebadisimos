extends Node

signal jugador_muerto(player_id: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var jugadores = get_tree().get_nodes_in_group("jugadores");
	if jugadores.size() < 2:
		print("El jugador " + jugadores.get(0).name + " gana!")
		get_tree().reload_current_scene()
		pass
