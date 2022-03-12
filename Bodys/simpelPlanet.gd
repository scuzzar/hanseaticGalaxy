@tool
extends RigidDynamicBody3D

class_name simpelPlanet

@export 
var material = preload("res://Bodys/materials/Mars.material") 

@export var isStar = false
@export var isPlanet = false
@export var doRotationShift = true
@export var securety_level = ENUMS.SECURETY.CORE

var orbital_speed :float = 0
@export var planetaryRotation :float= 0
@export var radius_description:float = 6371
@export var surface_g = 5.0

@onready var orbit_radius : float 

#var orbit
var angle : float = 0
var radius : float
var isGravetySource = false
var angular_speed : float = 0 
var non_shifted_angular_speed : float = 0 

var unshifted_linear_velocity  = Vector3(0,0,0)

var _last_global_pos:Vector3

func _enter_tree():
	self.add_to_group("bodys")
	self.gravity_scale = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	orbit_radius = position.length()
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
		if(parent is RigidDynamicBody3D):
			parent.derive_mass()
		var M = get_parent().mass
		var kosmic = sqrt(G*M/r)
		print(str(self.name) + " O_Speed:" + str(kosmic) + " O_perimeter:" + str(2*PI*orbit_radius))
		orbital_speed = kosmic
		angular_speed = 2*PI/(2*PI*orbit_radius/orbital_speed)	
		non_shifted_angular_speed = angular_speed
		if(!Engine.editor_hint):
			angle = Globals.RAN.randf_range(0,PI*2)
		else:
			angle = 0
		derive_pos_and_vel()
	else:
		print(position)

func derive_pos_and_vel():
	self.translation = Vector3(0,0,orbit_radius).rotated(Vector3(0,1,0),angle)
	_last_global_pos = self.global_transform.origin
	var s = Vector3(orbital_speed,0,0).rotated(Vector3(0,1,0), angle)
	var pvshift = get_parent().unshifted_linear_velocity
#	var vshift = Globals.velocity_shift
	#unshifted_linear_velocity = s + pvshift
	linear_velocity = s + pvshift #unshifted_linear_velocity + Globals.velocity_shift	

func derive_mass():
	var s = radius_description/6371.0*68	
	$Shape.scale = Vector3(s,s,s)		
	radius = $Shape/Mesh.get_aabb().get_longest_axis_size()*s/2	
	mass = (surface_g*radius*radius)/Globals.G

func _physics_process(delta):	
	if(!Engine.editor_hint and !isStar):		
		angle += (angular_speed *delta)	
		if(angle >= 2*PI): angle -= 2*PI
		
		self.translation = Vector3(0,0,orbit_radius).rotated(Vector3(0,1,0),angle)
		
		#update velocety
		self.linear_velocity = (global_transform.origin - _last_global_pos)/delta
		_last_global_pos = self.global_transform.origin


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
		"filename" : scene_file_path,
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
	
