extends Spatial

class_name Satellite
onready var orbit_radius = translation.length()
var linear_velocity = Vector3(0,0,0)
var angle = 0
var angular_speed = 0 
var global_translation = Vector3(0,0,0)

func _ready():	
	var r = orbit_radius
	var G = Globals.G
	var M = get_parent().mass
	var kosmic = sqrt(G*M/r)
	
	if(orbit_radius>0.5):
		angular_speed = 2*PI/(2*PI*orbit_radius/kosmic)	
		angle = asin(translation.x/orbit_radius)	
		var start = translation
		var result = [start]


func _physics_process(delta):
	angle += (angular_speed *delta)	
	if(angle >= 2*PI): angle -= 2*PI
	var pX = sin(angle)*orbit_radius
	var pZ = cos(angle)*orbit_radius
	
	linear_velocity = (Vector3(pX,0,pZ) -translation )/delta	
	linear_velocity = Vector3(linear_velocity.z,0,linear_velocity.x)
	
	#calculation is wrong
	
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
