tool
extends RigidBody

class_name simpelPlanet

export (Material) var material = preload("res://Bodys/materials/Mars.material") 

export var isStar = false
export var isPlanet = false
export var doRotationShift = true
export(ENUMS.SECURETY) var securety_level = ENUMS.SECURETY.CORE

var orbital_speed :float = 0
export var planetaryRotation :float= 0
export var radius_description:float = 6371
export(float) var surface_g = 5

onready var orbit_radius : float 

#var orbit
var angle : float = 0
var radius : float
var isGravetySource = false
var angular_speed : float = 0 
var non_shifted_angular_speed : float = 0 
var pX :float
var pZ :float

func _enter_tree():
	self.add_to_group("bodys")
	self.gravity_scale = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	orbit_radius = translation.length()
	$Shape/Mesh.material_override = material
	isGravetySource = (surface_g>0)
	$Lable3D.text = name
	if(self.securety_level==ENUMS.SECURETY.BELT):
		$Lable3D.text += "*"
	
	self.derive_mass()
	
	if(!isStar):
		var r = orbit_radius
		var G = Globals.G
		var parent = get_parent()
		if(parent is RigidBody):
			parent.derive_mass()
		var M = get_parent().mass
		var kosmic = sqrt(G*M/r)
		print(self.name + " O_Speed:" + str(kosmic) + " O_perimeter:" + str(2*PI*orbit_radius))
		orbital_speed = kosmic
		angular_speed = 2*PI/(2*PI*orbit_radius/orbital_speed)	
		non_shifted_angular_speed = angular_speed
		angle = asin(translation.x/orbit_radius)	
		var start = translation
		var result = [start]
	else:
		print(translation)

func derive_mass():
	var s = radius_description/6371.0*68	
	$Shape.scale = Vector3(s,s,s)		
	radius = $Shape/Mesh.get_aabb().get_longest_axis_size()*s/2	
	mass = (surface_g*radius*radius)/Globals.G

func _integrate_forces(state):
	var delta = state.step
	if ! isStar and !Engine.editor_hint:	
		angle += (angular_speed *delta)	
		if(angle >= 2*PI): angle -= 2*PI
		
		var x =  sin(angle)*orbit_radius
		var z = cos(angle)*orbit_radius
		var dx = x - self.pX 
		var dz = z - self.pZ
		self.pX = x
		self.pZ = z
		self.translation = Vector3(x,0,z)
		
		#state.transform.origin = Vector3(x,0,z)
		#state.linear_velocity = Vector3(dx,0,dz)
		
		# = Vector3(pX,0,pZ)
		#Needs further fixing
	#	self.rotate_y(planetaryRotation*delta)
	pass

func predictGlobalPosition(delta):
	if(isStar):
		return self.translation
	var sim_angle = angle +  (angular_speed *delta)	
	if(sim_angle >= 2*PI): sim_angle -= 2*PI
	var local_prediction = Vector3(sin(sim_angle)*orbit_radius,0,cos(sim_angle)*orbit_radius)
	var global_prediction = get_parent().predictGlobalPosition(delta)+local_prediction
	return global_prediction

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),		
		"angle" : angle,
		"orbit_radius" : orbit_radius
	}
	var savePos = self.translation		
	save_dict["pos_x"] = savePos.x
	save_dict["pos_y"] = savePos.y
	save_dict["pos_z"] = savePos.z
	return save_dict

func load_save(dict):
	angle=dict["angle"]
	orbit_radius=dict["orbit_radius"]
	transform.origin = Vector3(dict["pos_x"], dict["pos_y"],dict["pos_z"])	
	
