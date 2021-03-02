tool
extends RigidBody

class_name Rigid_N_Body

#export var mass = 200
export var velocety = Vector3(0,0,0)

export var isGravetySource = false

export(NodePath) var SOI_Body

onready var soi_node = self.get_node(SOI_Body)
export var show_soi_relativ_sim = true

var g_force = Vector3(0,0,0)

var G = 50

onready var bodys = []

var simulation_pos = []
var simulation_vel = []
export var show_sim = true

var history = []
export var history_lenth = 100
export var history_update_interfall = 0.5
var history_update_timer = 0

var orbit

func _enter_tree():
	self.add_to_group("bodys")
	self.gravity_scale = 0
	orbit = preload("res://N_Body/3DOrbit.gd").new()
	
	self.get_parent().call_deferred("add_child", orbit)

func _ready():
	if soi_node != null:
		bodys = [soi_node]
	else:
		bodys = get_tree().get_nodes_in_group("bodys")
	self.linear_velocity = velocety
	g_force = g_force(translation)	


func _process(delta):
	history_update_timer += delta
	#orbit._draw_list(simulation)
	if history_update_timer >= history_update_interfall:		
		history_update_timer -= history_update_interfall
		appendHistory()

func _integrate_forces(state):	
	g_force = g_force(self.translation)
	state.add_central_force(g_force / 2)
	state.add_central_force(g_force / 2)
	self.velocety = state.linear_velocity

func _leap_frog_integration(delta):
	velocety += g_force * delta / mass / 2
	self.translation += velocety*delta
	g_force = g_force(self.translation)
	velocety += g_force * delta / mass / 2

func appendHistory():	
	history.append(translation)
	if(history.size()>history_lenth):
		history.pop_front()
	pass

func g_force(position,t_plus=0):
	var sum = Vector3(0,0,0)
	if(bodys==null):
		print("no bodys")
		return Vector3(0,0,0)
	for body in bodys :
		if body != self && body.isGravetySource:
			var other_translation
			if(t_plus == 0):
				other_translation = body.translation
			else:
				other_translation = body.simulation_pos[t_plus-1]			
			var sqrDst = position.distance_squared_to(other_translation)		
			var forcDir = position.direction_to(other_translation).normalized()		
			var acceleration = forcDir * G *body.mass * mass / sqrDst
			sum += acceleration
		#Gravety_acceleration_components.append(acceleration)
	return sum

