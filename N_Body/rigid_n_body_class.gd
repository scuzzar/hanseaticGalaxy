tool
extends RigidBody

class_name Rigid_N_Body

#export var mass = 200
export var velocety = Vector3(0,0,0)

export var isGravetySource = false

export(NodePath) var SOI_Body

onready var soi_node = self.get_node_or_null(SOI_Body)
export var show_soi_relativ_sim = true

signal g_force_update(force,strogest_body,strongest_body_force)
signal strongest_body_changed(old_body,new_body)

var last_g_force = Vector3(0,0,0)
var last_g_force_strongest_Body : RigidBody
var last_g_force_strongest_Body_force = Vector3(0,0,0)

var G = 50

onready var bodys = []

var simulation_pos = []
var simulation_vel = []
export var show_sim = true

func _enter_tree():
	#self.add_to_group("bodys")
	self.gravity_scale = 0


func _ready():
	if soi_node != null:
		bodys = [soi_node]
	else:
		bodys = get_tree().get_nodes_in_group("bodys")
	self.linear_velocity = velocety
	last_g_force = g_force(translation)	


func _integrate_forces(state):
	state.add_central_force(last_g_force / 2)
	last_g_force = g_force(self.translation)
	emit_signal("g_force_update",last_g_force,last_g_force_strongest_Body,last_g_force_strongest_Body_force)	
	state.add_central_force(last_g_force / 2)
	self.velocety = state.linear_velocity




func g_force(position):
	
	var g_force_strongest_Body = null
	var g_force_strongest_Body_force = Vector3(0,0,0)
	
	var sum = Vector3(0,0,0)
	if(bodys==null):
		print("no bodys")
		return Vector3(0,0,0)
	for body in bodys :
		if body != self && body.isGravetySource:			
			var other_translation
			other_translation = body.get_parent().to_global(body.translation)				
			var sqrDst = position.distance_squared_to(other_translation)		
			var forcDir = position.direction_to(other_translation).normalized()		
			var acceleration = forcDir * G *body.mass * mass / sqrDst
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

