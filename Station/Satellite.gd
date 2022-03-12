extends Node3D

class_name Satellite
var orbit_radius = 0
var linear_velocity = Vector3(0,0,0)
var angle = 0
var angular_speed = 0 
var orbital_speed
var global_translation = Vector3(0,0,0)

func _ready():	
	if(orbit_radius!=0):
		_update_orbit()
	else:
		if(position.length()!=0):
			orbit_radius = position.length()
			_update_orbit()
			_physics_process(0)
		else:
			return

func _update_orbit():
	var r = orbit_radius
	var G = Globals.G
	var M = get_parent().mass
	var kosmic = sqrt(G*M/r)
	
	if(orbit_radius>0.5):
		angular_speed = 2*PI/(2*PI*orbit_radius/kosmic)
		orbital_speed = kosmic
		angle = acos(position.z/orbit_radius)	


func _physics_process(delta):
	angle += (angular_speed *delta)	
	if(angle >= 2*PI): angle -= 2*PI
		
	self.translation = Vector3(0,0,orbit_radius).rotated(Vector3(0,1,0),angle)
	var s = Vector3(orbital_speed,0,0).rotated(Vector3(0,1,0), angle)
	linear_velocity = s
	

func save():
	var save_dict = {
		"filename" : scene_file_path,
		"parent" : get_parent().get_path(),		
		"angle" : angle,
		"angular_speed" : angular_speed,
		"orbit_radius" : orbit_radius
	}
	return save_dict

func load_save(dict):
	angle=dict["angle"]
	orbit_radius=dict["orbit_radius"]
	angular_speed = dict["angular_speed"]

