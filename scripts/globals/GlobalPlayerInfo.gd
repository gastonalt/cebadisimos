extends Node

const PersonajeClass = preload("res://scripts/clases/Personaje.gd")

var jugadores: Array = []
var player_count: int = 2

func _ready() -> void:
	create_players(2)

func create_players(count: int) -> void:
	jugadores.clear()
	player_count = count
	for i in range(count):
		var p = PersonajeClass.new()
		p.player_id = i + 1
		if i == 0:
			p.player_skin = "player1.png"
		elif i == 1:
			p.player_skin = "player2.png"
		else:
			p.player_skin = "player3.png"
		jugadores.append(p)

func get_alive_player_ids() -> Array:
	var alive: Array = []
	for p in jugadores:
		if not p.is_dead:
			alive.append(p.player_id)
	return alive

func get_alive_count() -> int:
	return get_alive_player_ids().size()

func reset_for_new_round() -> void:
	for p in jugadores:
		p.is_dead = false

func reset_for_new_match() -> void:
	for p in jugadores:
		p.is_dead = false
		p.is_ready = false
