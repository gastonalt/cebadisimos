extends MarginContainer

@onready var textureNode: TextureRect = $VBoxContainer/HBoxContainer/TextureContainer/Texture
@onready var titulo: Label = $VBoxContainer/Titulo
@export var id_jugador: int = -1

var index = 0

const textures = [
	"player1.png", "player2.png", "player3.png",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	titulo.text = "Jugador " + str(id_jugador) + " selecione skin"
	_change_texture(textures[index])

func _change_texture(txname: String) -> void:
	textureNode.texture = load("res://" + txname)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	previous()

func _on_next_btn_pressed() -> void:
	next()
