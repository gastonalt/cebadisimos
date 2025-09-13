extends Node

const Personaje = preload("res://scripts/clases/Personaje.gd")
var jugador = Personaje.new()

var jugadores = [Personaje.new(), Personaje.new()]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
