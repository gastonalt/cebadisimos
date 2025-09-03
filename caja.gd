extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("cajas")
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	for area in get_overlapping_areas():
		if(area.name == "areaImpacto") and area.owner.disparando:
			self.queue_free()
		pass

func _on_area_entered(area: Area2D) -> void:
	if ("disparando" in area.owner and area.owner.disparando == true) or area.name == "bala":
		self.queue_free()  # eliminamos la caja
