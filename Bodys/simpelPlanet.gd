tool
extends RigidBody

class_name simpelPlanet

export (Material) var material = preload("res://Bodys/materials/Mars.material") 


export var orbital_speed = 1
export var radius_description:float = 6371
export(float) var surface_g = 5

onready var orbit_radius = translation.length()

#var orbit
var angle = 0
var radius
var isGravetySource = false
var angular_speed = 0 

func _enter_tree():
	self.add_to_group("bodys")
	self.gravity_scale = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Shape/Mesh.material_override = material
	isGravetySource = (surface_g>0)
	
	var s = radius_description/6371.0*68	
	$Shape.scale = Vector3(s,s,s)	
	
	radius = $Shape/Mesh.get_aabb().get_longest_axis_size()*s/2
	
	mass = (surface_g*radius*radius)/Globals.G
	
	
	if(orbit_radius>0.5):
		angular_speed = 2*PI/(2*PI*orbit_radius/orbital_speed)	
		angle = asin(translation.x/orbit_radius)	
		var start = translation
		var result = [start]
		

func _integrate_forces(state):
	angle += (angular_speed *0.1)	
	if(angle >= 2*PI): angle -= 2*PI
	var target = Vector3(sin(angle)*orbit_radius,0,cos(angle)*orbit_radius)
	
	state.linear_velocity = target - state.transform.origin 
	print(state.linear_velocity.length())

func _physics_process(delta):
	# TO DO: Change. This causes the Glitching of the Planet Position on TimeWarp
	# Physics bodys shall not be moved every frame (See Doc)
	#if !Engine.editor_hint:	
	#	angle += (angular_speed *delta)	
	#	if(angle >= 2*PI): angle -= 2*PI
	#	self.translation = Vector3(sin(angle)*orbit_radius,0,cos(angle)*orbit_radius)
	pass

func predictGlobalPosition(delta):
	var sim_angle = angle +  (angular_speed *delta)	
	if(sim_angle >= 2*PI): sim_angle -= 2*PI
	var local_prediction = Vector3(sin(sim_angle)*orbit_radius,0,cos(sim_angle)*orbit_radius)
	var global_prediction = get_parent().to_global(local_prediction)
	return global_prediction
