extends Spatial

class_name Satellite
var orbit_radius = 0
var linear_velocity = Vector3(0,0,0)
var angle = 0
var angular_speed = 0 
var global_translation = Vector3(0,0,0)

func _ready():	
	if(orbit_radius!=0):
		_update_orbit()
	else:
		if(translation.length()!=0):
			orbit_radius = translation.length()
			_update_orbit()
		else:
			return

func _update_orbit():
	var r = orbit_radius
	var G = Globals.G
	var M = get_parent().mass
	var kosmic = sqrt(G*M/r)
	
	if(orbit_radius>0.5):
		angular_speed = 2*PI/(2*PI*orbit_radius/kosmic)	
		angle = acos(translation.z/orbit_radius)	


func _physics_process(delta):
	angle += (angular_speed *delta)	
	if(angle >= 2*PI): angle -= 2*PI
	var pX = sin(angle)*orbit_radius
	var pZ = cos(angle)*orbit_radius
	
	linear_velocity = (Vector3(pX,0,pZ) -translation )/delta	
	linear_velocity = Vector3(linear_velocity.z,0,linear_velocity.x*-1)

	self.translation = Vector3(pX,0,pZ)
	

func save():
	var save_dict = {
		"filename" : get_filename(),
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

