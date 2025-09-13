extends Node

var marcador = [0,0]

signal jugador_muerto(player_id: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var jugadores = get_tree().get_nodes_in_group("jugadores");
	if jugadores and jugadores.size() < 2:
		print("El jugador " + jugadores.get(0).name + " gana la ronda")
		marcador[jugadores.get(0).player_id - 1] = marcador[jugadores.get(0).player_id - 1] + 1
		if marcador[0] == 5 or marcador[1] == 5:
			print("El jugador " + jugadores.get(0).name + " gana la partida entera")
			get_tree().change_scene_to_file("res://seleccionar_jugador_menu.tscn")
		else:
			get_tree().reload_current_scene()
		pass
