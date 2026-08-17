extends Area2D

func _ready() -> void:
	add_to_group("cajas")

func _on_area_entered(area: Node2D) -> void:
	if area.name == "bala" or area.name == "AreaImpacto":
		queue_free()
