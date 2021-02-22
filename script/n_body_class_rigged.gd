extends RigidBody

class_name RiggednBody

#export var mass = 200
export var velocety = Vector3(0,0,0)

export var isGravetySource = false

var g_force = Vector3(0,0,0)

var G = 100

onready var bodys = get_tree().get_nodes_in_group("bodys")

var simulation = []
export var simulation_steps = 100
var simulation_delta_t = 0.1
var simulatoin_update_interfall = 0.3
var simulation_orbit_treshold = 0.3
var simulation_update_timer = 0

var history = []
export var history_lenth = 100
var history_update_interfall = 0.1
var history_update_timer = 0

func _enter_tree():
	if isGravetySource : self.add_to_group("bodys")
# Called when the node enters the scene tree for the first time.
func _ready():
	g_force = g_force(translation)	

func _process(delta):
	simulation_update_timer += delta
	history_update_timer += delta
	if simulation_update_timer >= simulatoin_update_interfall:
		simulation_update_timer -= simulatoin_update_interfall
		simulate()	
	if history_update_timer >= history_update_interfall:		
		history_update_timer -= history_update_interfall
		appendHistory()

func _physics_process(delta):
	_leap_frog_integration(delta)

func _leap_frog_integration(delta):
	#linear_velocity += g_force * delta / mass / 2
	#var collision = move_and_collide(velocety*delta)
	#if collision != null:
	#	velocety = velocety.bounce(collision.normal)
	g_force = g_force(self.translation)
	#linear_velocity += g_force * delta / mass / 2

func appendHistory():	
	history.append(translation)
	if(history.size()>history_lenth):
		history.pop_front()
	pass

func simulate():
	var sim_ship_start_pos = translation
	var sim_ship_pos = sim_ship_start_pos
	var sim_ship_val = velocety
	var sim_g_force = g_force(sim_ship_pos)	
	simulation = [sim_ship_pos]
	for i in simulation_steps:		
		sim_ship_val += sim_g_force * simulation_delta_t / mass /2
		sim_ship_pos += sim_ship_val * simulation_delta_t
		
		sim_g_force = g_force(sim_ship_pos)	
		sim_ship_val += sim_g_force * simulation_delta_t / mass /2
		
		simulation.append(sim_ship_pos)
		if sim_ship_pos.distance_to(sim_ship_start_pos) < simulation_orbit_treshold:
			break

func g_force(position):
	var sum = Vector3(0,0,0)
	for body in bodys :
		if body != self:
			var sqrDst = position.distance_squared_to(body.translation)		
			var forcDir = position.direction_to(body.translation).normalized()		
			var acceleration = forcDir * G *body.mass / sqrDst
			sum += acceleration
		#Gravety_acceleration_components.append(acceleration)
	return sum

