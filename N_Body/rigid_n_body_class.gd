extends RigidDynamicBody3D

class_name Rigid_N_Body

signal g_force_update(force,strogest_body,strongest_body_force)
signal strongest_body_changed(old_body,new_body)

var last_g_force = Vector3(0,0,0)
var last_g_force_strongest_Body : RigidDynamicBody3D
var last_g_force_strongest_Body_force = Vector3(0,0,0)

var write_linear_velocity = null

@export 
var physicActiv =false

@onready var bodys = []

func _enter_tree():
	self.gravity_scale = 0


func _ready():
	bodys = get_tree().get_nodes_in_group("bodys")


func _integrate_forces(state):
	state.add_central_force(last_g_force / 2)	
	last_g_force = g_force(self.translation)
	emit_signal("g_force_update",last_g_force,last_g_force_strongest_Body,last_g_force_strongest_Body_force)	
	state.add_central_force(last_g_force / 2)
	if(write_linear_velocity!=null):
		print("overwriting ship Velocyty:" + str(write_linear_velocity))
		state.linear_velocity = write_linear_velocity
		write_linear_velocity = null
	self.linear_velocity =state.linear_velocity

func set_write_linear_velocity(v:Vector3):
	write_linear_velocity = v

func g_force(pPosition):
	#Slow
	bodys = get_tree().get_nodes_in_group("bodys")
	
	var g_force_strongest_Body = last_g_force_strongest_Body
	var g_force_strongest_Body_force = Vector3(0,0,0)
	
	var sum = Vector3(0,0,0)
	if(bodys==null):
		print("no bodys")
		return Vector3(0,0,0)
	for body in bodys :
		if body != self && body.isGravetySource:			
			var other_translation
			other_translation = body.get_parent().to_global(body.translation)				
			var sqrDst = pPosition.distance_squared_to(other_translation)		
			var forcDir = pPosition.direction_to(other_translation).normalized()		
			var acceleration = forcDir * Globals.G *body.mass * mass / sqrDst
			sum += acceleration
			if(g_force_strongest_Body_force.length()<acceleration.length()):
				g_force_strongest_Body_force = acceleration
				g_force_strongest_Body = body
	if(g_force_strongest_Body != last_g_force_strongest_Body):
		var old_stronges_body = last_g_force_strongest_Body
		last_g_force_strongest_Body = g_force_strongest_Body
		last_g_force_strongest_Body_force = g_force_strongest_Body_force
		emit_signal("strongest_body_changed",old_stronges_body,g_force_strongest_Body)	
		
	return sum	

