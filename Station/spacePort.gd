extends Spatial

class_name Port


func _on_Area_body_entered(body):
	if(body is Ship):
		var ship := body as Ship
		ship.fuel = ship.fuel_cap
