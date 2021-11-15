extends Area2D

func _on_BlackHole_area_entered(area):
	if area.is_in_group("Player"):
		area.damage(10)
