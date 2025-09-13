extends Area2D
## @onready var personaje: CharacterBody2D = get_node("../Personaje")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
## 	personaje.canShoot = true
	var armas_agarradas = body.get_node("arma_holder").get_children()
	for arma in armas_agarradas:
		arma.free()
	var arma_scene = load("res://scenes/pistola.tscn") ## por defecto
	match(owner.tipo_arma):
		1:
			arma_scene = load("res://scenes/pistola.tscn")
		2:
			arma_scene = load("res://scenes/escopeta.tscn")
	var arma = arma_scene.instantiate()
	arma.player_id = body.player_id
	body.get_node("arma_holder").add_child(arma)
	self.queue_free()
