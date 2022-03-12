extends Node

@export var simulation_time = 100
@export var simulation_time_inc = 300
@export var simulation_delta_t = 1.0
@export var simulatoin_update_interfall = 1.0

@export_node_path var _simulation_object_path

@onready var _simulation_Object:Rigid_N_Body = get_node_or_null(_simulation_object_path)

@export var on = false
@export var relativ_to_soi = false


var simulation_pos = []
var simulation_vel = []


var simulation_update_timer = 0

var bodys = []

func _ready():
	bodys = get_tree().get_nodes_in_group("bodys")	
	$TargetPoint.hide()
	$TargetPoint/Lable3D.hide()	

func start():
	on = true
	$Path.show()

func stop():
	on = false
	$Path.path = []
	$Path.hide()
	$TargetPoint.hide()
	$TargetPoint/Lable3D.hide()

func toggel():
	if(on):
		stop()
	else:
		start()

func _process(delta):
	
	if Input.is_action_just_pressed("simulate"):
		self.toggel()
	
	if(on):
		if Input.is_action_just_pressed("simulate_more"):
			simulation_time +=simulation_time_inc
		
		if Input.is_action_just_pressed("simulate_less"):
			if(simulation_time -simulation_time_inc>0):
				simulation_time -=simulation_time_inc
		
		if(Engine.time_scale<2):
			simulation_update_timer += delta
		else:
			simulation_update_timer = 0	
	
		if simulation_update_timer >= simulatoin_update_interfall:
			simulation_update_timer = 0
			simulate()
	#end is on

func simulate():
	$TargetPoint.hide()
	$TargetPoint/Lable3D.hide()
	if(!on):return
	if(bodys==null):return
	
	var sim_obj_pos = _simulation_Object.translation
	var sim_obj_val = _simulation_Object.velocety
	
	simulation_pos = [sim_obj_pos]
	simulation_vel = [sim_obj_val]

	var stronges_body_chang_count = 0
	var step_size_inc = 1
	
	var sim_g_force = Vector3(0,0,0)
	
	var t = 0
	var steps = 0
	while(t<simulation_time):
		
		if(sim_g_force.length()>0):
			step_size_inc =clamp(0.1/sim_g_force.length(),0.1,100)
		
		t += simulation_delta_t * step_size_inc
		steps += 1
		var strongest_body:simpelPlanet = _simulation_Object.last_g_force_strongest_Body	
		
		sim_g_force = Vector3(0,0,0)
		
		var temp_strongest_body:simpelPlanet = strongest_body
		var temp_strongest_body_force :float = 0	
		var temp_strongest_body_pos = Vector3(0,0,0)
		
		for body in bodys:
			var planet:simpelPlanet= body as simpelPlanet
			if planet != self && planet.isGravetySource:
				var other_translation = planet.predictGlobalPosition(t)
				var sqrDst = sim_obj_pos.distance_squared_to(other_translation)
				#if(sqrDst <= planet.radius*planet.radius):return	
				
				var forcDir = sim_obj_pos.direction_to(other_translation).normalized()		
				var acceleration = forcDir * Globals.G *planet.mass  / sqrDst
				sim_g_force += acceleration
				if(acceleration.length()>temp_strongest_body_force):
					temp_strongest_body_force = acceleration.length()
					temp_strongest_body = planet
					temp_strongest_body_pos = other_translation
					
		## end body Loop
		


		sim_obj_val += sim_g_force   * simulation_delta_t /2
		sim_obj_pos += sim_obj_val * simulation_delta_t
		sim_obj_val += sim_g_force   * simulation_delta_t /2
		
		simulation_pos.append(sim_obj_pos)
		
		if(temp_strongest_body!=strongest_body): #and temp_strongest_body.isPlanet):
			strongest_body = temp_strongest_body 
			stronges_body_chang_count += 1
			if(stronges_body_chang_count==1):		
				$TargetPoint.translation = temp_strongest_body_pos
				$TargetPoint/Lable3D.text = strongest_body.name	
				$TargetPoint/Lable3D.show()
				$TargetPoint.show()
				$TargetPoint.scale = Vector3(1,1,1) * strongest_body.radius
			if(stronges_body_chang_count==2):
				break
	## end Time step loop
	print("simSteps Needed:" + str(steps))
	$Path.path = simulation_pos



func _on_Shifter_shifted():
	simulate()
