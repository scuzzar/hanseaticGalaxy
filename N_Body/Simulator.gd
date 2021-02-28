tool
extends Node

export var simulation_steps = 1000
export var simulation_delta_t = 1
export var simulatoin_update_interfall = 1
export var on = false

export var relativ_to_soi = false

var simulation_orbit_treshold = 0.1
var simulation_update_timer = 0

var bodys

func _ready():
	bodys = get_tree().get_nodes_in_group("bodys")
	simulate()
	pass # Replace with function body.

func _process(delta):
	simulation_update_timer += delta	
	if simulation_update_timer >= simulatoin_update_interfall:
		simulation_update_timer -= simulatoin_update_interfall
		if(on):simulate()

func simulate():
	for body in bodys:
		body.simulation_pos = []
		body.simulation_vel = []
	
	for t in simulation_steps:
		for body in bodys:
			var sim_ship_pos
			var sim_ship_val
			if(t==0):
				sim_ship_pos = body.translation
				sim_ship_val = body.velocety				
			else:
				sim_ship_pos = body.simulation_pos[t-1]
				sim_ship_val = body.simulation_vel[t-1]				
			
			if(body.mode != body.MODE_STATIC):
				var sim_g_force = body.g_force(sim_ship_pos,t)	
				
				sim_ship_val += sim_g_force * simulation_delta_t / body.mass /2
				sim_ship_pos += sim_ship_val * simulation_delta_t
					
				sim_g_force = body.g_force(sim_ship_pos,t)	
				sim_ship_val += sim_g_force * simulation_delta_t / body.mass /2
			
			body.simulation_pos.append(sim_ship_pos)
			body.simulation_vel.append(sim_ship_val)

	for body in bodys:
		if(body.show_sim):
			if(body.soi_node !=null and body.show_soi_relativ_sim):
				var soi_rel_simulaiton_pos = []
				for t in body.simulation_pos.size():
					soi_rel_simulaiton_pos.append(body.simulation_pos[t]-body.soi_node.simulation_pos[t]+body.soi_node.translation)
				body.orbit.draw_list(soi_rel_simulaiton_pos)
			else:
				body.orbit.draw_list(body.simulation_pos)
		else:
			body.orbit.clear()
		
