extends MarginContainer

@onready var textureNode: TextureRect = $VBoxContainer/HBoxContainer/TextureContainer/Texture
@onready var readyBtn: Button = $VBoxContainer/readyButton
@onready var siguienteBtn: Button = $VBoxContainer/HBoxContainer/NextBtn
@onready var previoBtn: Button = $VBoxContainer/HBoxContainer/PrevBtn
@onready var titulo: Label = $VBoxContainer/Titulo
@export var id_jugador: int = -1
@onready var cuentaAtras: Label = $"../../CuentaAtras"

var index = 0
var isPlayerReady = false
var tiempo = 3

const textures = [
	"player1.png", "player2.png", "player3.png",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	titulo.text = "Jugador " + str(id_jugador) + " selecione skin"
	_change_texture(textures[index])

func _change_texture(txname: String) -> void:
	textureNode.texture = load("res://sprites/" + txname)
	GlobalPlayerInfo.jugadores[id_jugador - 1].player_skin = txname

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var prefix = "p%d_" % id_jugador
	if Input.is_action_just_pressed(prefix + "left") and !isPlayerReady:
		previous()
	if Input.is_action_just_pressed(prefix + "right") and !isPlayerReady:
		next()
	pass

func previous() -> void:
	if index != 0:
		index = index - 1
		_change_texture(textures[index])
	else:
		index = textures.size() - 1
		_change_texture(textures[index])
	
func next() -> void:
	if index != textures.size() - 1:
		index = index + 1
		_change_texture(textures[index])
	else:
		index = 0
		_change_texture(textures[index])

func _on_prev_btn_pressed() -> void:
	if !isPlayerReady:
		previous()

func _on_next_btn_pressed() -> void:
	if !isPlayerReady:
		next()

func _on_ready_button_pressed() -> void:
	isPlayerReady=!isPlayerReady
	if isPlayerReady:
		siguienteBtn.disabled = true
		previoBtn.disabled = true
		readyBtn.text = "CAMBIAR"
		GlobalPlayerInfo.jugadores[id_jugador - 1].is_ready = true
	else:
		readyBtn.text = "LISTO"
		siguienteBtn.disabled = false
		previoBtn.disabled = false
		GlobalPlayerInfo.jugadores[id_jugador - 1].is_ready = false
	_check_both_ready()


var countdown_active = false

func _check_both_ready() -> void:
	tiempo = 3
	if GlobalPlayerInfo.jugadores[0].is_ready and GlobalPlayerInfo.jugadores[1].is_ready:
		countdown_active = true
		cuentaAtras.visible = true
		while tiempo > 0 and countdown_active:
			cuentaAtras.text = "El juego comienza en %d..." % tiempo
			await get_tree().create_timer(1.0).timeout
			tiempo -= 1
			# Si algún jugador deja de estar listo, cancelar
			if not (GlobalPlayerInfo.jugadores[0].is_ready and GlobalPlayerInfo.jugadores[1].is_ready):
				countdown_active = false
				break
		if countdown_active:
			cuentaAtras.text = "¡A jugar!"
			await get_tree().create_timer(1.0).timeout
			get_tree().change_scene_to_file("res://scenes/level.tscn")
		else:
			cuentaAtras.visible = false
	else:
		countdown_active = false
		tiempo = 3
		cuentaAtras.visible = false
