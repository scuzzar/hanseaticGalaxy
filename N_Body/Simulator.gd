extends Node

export var simulation_time = 100
export var simulation_delta_t = 1.0
export var simulatoin_update_interfall = 1

export(NodePath) var _simulation_object_path
onready var _simulation_Object:Rigid_N_Body = get_node_or_null(_simulation_object_path)

export var on = false
export var relativ_to_soi = false

#export(NodePath) var _Target_object_path
#onready var _target_Object:Rigid_N_Body = get_node_or_null(_simulation_object_path)

#var simulation_orbit_treshold = 0.1

var simulation_pos = []
var simulation_vel = []


var simulation_update_timer = 0

var bodys = []

func _ready():
	bodys = get_tree().get_nodes_in_group("bodys")	
	$TargetPoint.hide()	

func start():
	on = true
	$Path.show()

func stop():
	on = false
	$Path.path = []
	$Path.hide()
	$TargetPoint.hide()

func toggel():
	if(on):
		stop()
	else:
		start()

func _process(delta):
	simulation_update_timer += delta	
	if simulation_update_timer >= simulatoin_update_interfall:
		simulation_update_timer -= simulatoin_update_interfall
		if(on):
			simulate()
			$Path.path = simulation_pos

func simulate():
	$TargetPoint.hide()
	if(!on):return
	if(bodys==null):return

	var simulation_steps = simulation_time/simulation_delta_t
	var sim_obj_pos = _simulation_Object.translation
	var sim_obj_val = _simulation_Object.velocety
	
	simulation_pos = [sim_obj_pos]
	simulation_vel = [sim_obj_val]
	var near_Planet = false
	
	var simSOI = null	
	var simMaxG = 0
		
	#_simulation_Object.simulation_pos = []
	var stronges_body_chang_count = 0
	for i in simulation_steps:
		var t = i * simulation_delta_t
		var strongest_body:simpelPlanet = _simulation_Object.last_g_force_strongest_Body
		var strongest_body_force :float = _simulation_Object.last_g_force_strongest_Body_force.length()
		
		if(stronges_body_chang_count>1): return
		var sim_g_force = Vector3(0,0,0)
		for body in bodys:
			var planet:simpelPlanet= body as simpelPlanet		
			if planet != self && planet.isGravetySource:			
				var other_translation = planet.predictGlobalPosition(t)
				var sqrDst = sim_obj_pos.distance_squared_to(other_translation)
				if(sqrDst <= planet.radius*planet.radius):return	
				var forcDir = sim_obj_pos.direction_to(other_translation).normalized()		
				var acceleration = forcDir * _simulation_Object.G *planet.mass  / sqrDst
				if(acceleration.length()>strongest_body_force):
					strongest_body_force = acceleration.length()
					strongest_body = planet
					stronges_body_chang_count += 1
					$TargetPoint.translation = other_translation	
					$TargetPoint.show()
					$TargetPoint.scale = Vector3(1,1,1) * planet.radius	
				sim_g_force += acceleration
				var sqrRadius = planet.radius*planet.radius
			
					

		sim_obj_val += sim_g_force   * simulation_delta_t /2
		sim_obj_pos += sim_obj_val * simulation_delta_t
		sim_obj_val += sim_g_force   * simulation_delta_t /2
		
		simulation_pos.append(sim_obj_pos)


		
		#var new_relativ_point = sim_obj_pos-_simulation_Object.last_g_force_strongest_Body.global_transform.origin	
		#_simulation_Object.simulation_pos.append(sim_obj_pos)
