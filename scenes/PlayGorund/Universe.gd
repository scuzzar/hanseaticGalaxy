extends Node

export var G = 100
onready var bodys = get_tree().get_nodes_in_group("bodys")

func g_force(position):
	var sum = Vector3(0,0,0)
	for body in bodys :
		var sqrDst = position.distance_squared_to(body.translation)		
		var forcDir = position.direction_to(body.translation).normalized()		
		var acceleration = forcDir * G *body.mass / sqrDst
		sum += acceleration
		#Gravety_acceleration_components.append(acceleration)
	return sum
