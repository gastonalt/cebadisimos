extends Area2D

## Weapon pickup area. Instantiates a weapon and attaches it to the player's RightHand.

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("jugadores"):
		return
	if not body.has_node("RightHand"):
		return

	var hand = body.get_node("RightHand")

	# Remove existing weapons
	for child in hand.get_children():
		if child is WeaponBase:
			child.queue_free()

	# Load weapon scene
	var tipo = 1
	if owner and owner.has_method("get") and "tipo_arma" in owner:
		tipo = owner.tipo_arma
	elif owner and owner.has_method("get"):
		# Try parent
		var par = owner.get_parent()
		if par and "tipo_arma" in par:
			tipo = par.tipo_arma

	var weapon_scene: PackedScene
	match tipo:
		1:
			weapon_scene = load("res://scenes/pistola.tscn")
		2:
			weapon_scene = load("res://scenes/escopeta.tscn")
		_:
			weapon_scene = load("res://scenes/pistola.tscn")

	var arma = weapon_scene.instantiate()
	hand.add_child(arma)
	self.queue_free()
