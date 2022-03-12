extends Node


@onready var ship = get_parent()


func _lateral_circularize_burn(state):
	var ov = self._get_orbital_vector()
	var c_burn_direction = ov - state.linear_velocity
	var c_burn_dv = c_burn_direction.length()
	
	var c_burn_trust = clamp(ship.get_lateral_trust() ,0,c_burn_dv/state.step)			
	var orientation = ship.rotation.y
	var c_burn_direction_local = c_burn_direction.rotated(Vector3(0,1,0), -1*orientation+PI/2).normalized()
	var tv = Vector2(c_burn_direction_local.x,c_burn_direction_local.z)
	
	ship.truster_vector = tv
	ship.truster_trust = c_burn_trust



func _get_orbital_vector():
	var b :simpelPlanet = ship.last_g_force_strongest_Body
	#print(b.name)
	var b_direction : Vector3 =ship.global_transform.origin - b.global_transform.origin
	
	var orbital_direction = b_direction.normalized().rotated(Vector3(0,1,0),PI/2)
	
	var d =	b_direction.length()
	var M = b.mass
	var kosmic = sqrt(Globals.G*M/d)
	
	var orbital_vector_in_Sio =(orbital_direction * kosmic)
	
	#account for motion of b
	var result =orbital_vector_in_Sio+b.linear_velocity
	return result
