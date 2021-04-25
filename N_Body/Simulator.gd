extends Node

export var simulation_time = 100
export var simulation_delta_t = 1.0
export var simulatoin_update_interfall = 1

export(NodePath) var _simulation_object_path
onready var _simulation_Object:Rigid_N_Body = get_node_or_null(_simulation_object_path)

export var on = false

export var relativ_to_soi = false


#var simulation_orbit_treshold = 0.1
var simulation_update_timer = 0

var bodys = []

func _ready():
	bodys = get_tree().get_nodes_in_group("bodys")	
	
func _process(delta):
	simulation_update_timer += delta	
	if simulation_update_timer >= simulatoin_update_interfall:
		simulation_update_timer -= simulatoin_update_interfall
		if(on):simulate()

func simulate():
	if(bodys==null):return
	
	#for body in bodys:
	#	body.simulation_pos = []
	#	body.simulation_vel = []
	var simulation_steps = simulation_time/simulation_delta_t
	
	var sim_obj_pos = _simulation_Object.translation
	var sim_obj_val = _simulation_Object.velocety
	
	var simulation_pos = [sim_obj_pos]
	#var simulation_val = [sim_obj_val]
	
	for t in simulation_steps:
		for body in bodys:
			var planet:simpelPlanet= body as simpelPlanet	
			if planet != self && planet.isGravetySource:
			
				var other_translation = planet.predictGlobalPosition(t)
				
				var sqrDst = sim_obj_pos.distance_squared_to(other_translation)		
				var forcDir = sim_obj_pos.direction_to(other_translation).normalized()		
				var acceleration = forcDir * _simulation_Object.G *planet.mass * _simulation_Object.mass / sqrDst
				sim_obj_val += acceleration
		sim_obj_pos += sim_obj_val
		simulation_pos.append(sim_obj_pos)

		if(_simulation_Object.show_sim):
			_simulation_Object.orbit.draw_list(simulation_pos)
		else:
			_simulation_Object.orbit.clear()
		
