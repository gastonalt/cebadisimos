extends MarginContainer

@onready var textureNode: TextureRect = $VBoxContainer/HBoxContainer/TextureContainer/Texture
@onready var readyBtn: Button = $VBoxContainer/readyButton
@onready var siguienteBtn: Button = $VBoxContainer/HBoxContainer/NextBtn
@onready var previoBtn: Button = $VBoxContainer/HBoxContainer/PrevBtn
@onready var titulo: Label = $VBoxContainer/Titulo
@export var id_jugador: int = -1

var index = 0
var isPlayerReady = false

const textures = [
	"player1.png", "player2.png", "player3.png",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	titulo.text = "Jugador " + str(id_jugador) + " selecione skin"
	_change_texture(textures[index])

func _change_texture(txname: String) -> void:
	textureNode.texture = load("res://" + txname)
	GlobalPlayerInfo.playerSkin[id_jugador - 1] = txname

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
		GlobalPlayerInfo.playerReady[id_jugador - 1] = true
	else:
		readyBtn.text = "LISTO"
		siguienteBtn.disabled = false
		previoBtn.disabled = false
		GlobalPlayerInfo.playerReady[id_jugador - 1] = false
	_check_both_ready()

func _check_both_ready() -> void:
	if GlobalPlayerInfo.playerReady[0] and GlobalPlayerInfo.playerReady[1]:
		get_tree().change_scene_to_file("res://level.tscn")
