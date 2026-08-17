extends CanvasLayer

@onready var label: Label = $Label
var debug_visible: bool = false

func _ready() -> void:
	layer = 100
	debug_visible = false
	label.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_F1:
		debug_visible = !debug_visible
		label.visible = debug_visible

func _process(delta: float) -> void:
	if not debug_visible:
		return

	var texto = "=== DEBUG ===\n"
	texto += "GameState: %s\n" % GameState.State.keys()[GameState.current_state]
	texto += "FPS: %d\n" % Engine.get_frames_per_second()
	texto += "Jugadores: %d\n" % GlobalPlayerInfo.player_count
	texto += "Marcador: %s\n" % str(GameManager.marcador)

	var vivos = get_tree().get_nodes_in_group("jugadores")
	texto += "Vivos en escena: %d\n" % vivos.size()
	for j in vivos:
		texto += "  P%d - Pos: %s - Alive: %s\n" % [j.player_id, Vector2i(j.global_position), j.is_alive]

	texto += "Nivel: %s\n" % get_tree().current_scene.name
	label.text = texto
