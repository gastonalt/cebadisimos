extends Node

enum State { MAIN_MENU, CHARACTER_SELECT, COUNTDOWN, PLAYING, ROUND_END, MATCH_END, PAUSE }

var current_state: State = State.MAIN_MENU

var match_config: Dictionary = {
	"wins_needed": 3,
	"player_count": 2,
	"current_map_index": 0,
}

signal state_changed(old_state: State, new_state: State)

func change_state(new_state: State) -> void:
	if new_state == current_state:
		return
	var old = current_state
	current_state = new_state
	state_changed.emit(old, new_state)

func is_playing() -> bool:
	return current_state == State.PLAYING

func reset_match() -> void:
	match_config.current_map_index = 0
	change_state(State.MAIN_MENU)
