extends Node

class_name Personaje

var player_id: int
var player_skin: String = "player1.png"
var is_dead: bool = false
var is_ready: bool = false

const PLAYER_COLORS = {
	1: Color(0.72, 0.53, 0.3),    # Mate Criollo - marron
	2: Color(0.3, 0.7, 0.3),      # Mate Amargo - verde
	3: Color(0.9, 0.4, 0.55),     # Mate Dulce - rosa
	4: Color(0.3, 0.5, 0.85),     # Termo Mate - azul
}

func get_color() -> Color:
	return PLAYER_COLORS.get(player_id, Color.WHITE)
