extends Node

var marcador: Array = [0, 0, 0, 0]

signal jugador_muerto(player_id: int)
signal ronda_ganada(winner_id: int)
signal partida_ganada(winner_id: int)

var _round_ended: bool = false

func _ready() -> void:
	_round_ended = false
	if not jugador_muerto.is_connected(_on_jugador_muerto):
		jugador_muerto.connect(_on_jugador_muerto)

func on_player_died(victim_id: int) -> void:
	jugador_muerto.emit(victim_id)

func _on_jugador_muerto(victim_id: int) -> void:
	if _round_ended:
		return
	_round_ended = true

	var vivos = get_tree().get_nodes_in_group("jugadores")
	var ganador_id: int = 0
	for j in vivos:
		if j.is_alive:
			ganador_id = j.player_id
			break

	if ganador_id > 0:
		marcador[ganador_id - 1] += 1
		print("Jugador %d gana la ronda! Marcador: %s" % [ganador_id, str(marcador)])
		ronda_ganada.emit(ganador_id)

		if marcador[ganador_id - 1] >= GameState.match_config.wins_needed:
			print("Jugador %d gana la partida!" % ganador_id)
			partida_ganada.emit(ganador_id)
			GameState.change_state(GameState.State.MATCH_END)
			await get_tree().create_timer(3.0).timeout
			reset_match()
			get_tree().change_scene_to_file("res://scenes/seleccionar_jugador_menu.tscn")
		else:
			GameState.change_state(GameState.State.ROUND_END)
			await get_tree().create_timer(2.0).timeout
			GlobalPlayerInfo.reset_for_new_round()
			_round_ended = false
			GameState.change_state(GameState.State.PLAYING)
			get_tree().reload_current_scene()
	else:
		GameState.change_state(GameState.State.ROUND_END)
		await get_tree().create_timer(2.0).timeout
		GlobalPlayerInfo.reset_for_new_round()
		_round_ended = false
		GameState.change_state(GameState.State.PLAYING)
		get_tree().reload_current_scene()

func reset_match() -> void:
	marcador = [0, 0, 0, 0]
	_round_ended = false
	GlobalPlayerInfo.reset_for_new_match()
