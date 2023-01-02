extends Node3D


#var loader : ResourceInteractiveLoader
@onready var ship:Ship = $PlayerShip
@onready var all = self.get_children()

@export var MaxtimeWarpFactor = 1800
@export var WarpTargetSpeed_Sun = 30

@export var WarpTargetSpeed_Planet = 15
@export var WarpTargetSpeed_Moon = 200


@export var player_spawn_point_path : NodePath 
@onready var player_spawn_point:Port = get_node_or_null(player_spawn_point_path)

var loaded = false

func _ready():
	setShip(ship)	
	if(Globals.loadPath !=null):
		self.load_game()
	else:
		newGameSetup()		

func newGameSetup():	
	for cg in get_tree().get_nodes_in_group("cargoGenerator"):
		cg.generateInitialStock()
	ship.fuel = ship.fuel_cap
	Player.credits = 10000
	if(player_spawn_point!=null):
	
		ship.transform = player_spawn_point.get_docking_globaltransform()		
		var spawn_body :simpelPlanet = player_spawn_point.getBody()
		print("BodyV/t" + str(spawn_body.unshifted_linear_velocity) + " abs " +str(spawn_body.unshifted_linear_velocity.length()))
		
		var offset_vel = spawn_body.unshifted_linear_velocity
		
		
		if(!spawn_body.isPlanet):#Moon			
			var parent_body :simpelPlanet
			parent_body = spawn_body.get_parent()
			offset_vel += parent_body.unshifted_linear_velocity
		
		#if($RotationShifter.activ):
		#	offset_vel -= $RotationShifter.velocity_shift
		
		ship.linear_velocity = offset_vel	
		
		print("ship spawned at " + str(ship.position))
			
	ship.freeze = false
	loaded = true	

func setShip(newShip:Ship):
	newShip.strongest_body_changed.connect(_on_Ship_strongest_body_changed)	
	newShip.undocked.connect(_on_Ship_undocked)
	newShip.docked.connect(self._on_Ship_docked)
	$UI.setShip(newShip)
	
	$Camera.ship =newShip
	$Simulator._simulation_Object = newShip
	self.ship = newShip	
	Player.ship = newShip
	newShip.team = ENUMS.TEAM.PLAYER
	newShip.freeze = false
	
	newShip.playerControl = true

func _process(delta):
	if(! is_instance_valid(ship)):return
	
	if Input.is_action_just_pressed("debug_state"):
		print("_____Player Ship_________")
		print("pos:" + str(ship.transform.origin) + " + " +  str(ship.linear_velocity))
		print("SOI Vel" + str(ship.last_g_force_strongest_Body.constant_linear_velocity))
		print("gforce:"+ str(ship.last_g_force))
		print("Sun Position:" + str($Sun.global_transform.origin))
	
	if Input.is_action_pressed("endGame"):
		print("you ended the game!")
		call_deferred("_loadScore")
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if(DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
		#OS.window_fullscreen = !OS.window_fullscreen
	
	Engine.time_scale =  1
	
	if Input.is_action_pressed("time_delay"):
		var factor = clamp(1 / ship.last_g_force.length()*ship.mass,0.001,0.001)
		Engine.time_scale =  factor
	
	if Input.is_action_pressed("time_warp"):
		
		var p = ship.last_g_force_strongest_Body as simpelPlanet
		var factor = 1
		var g = ship.last_g_force_strongest_Body_force.length()
		var v = ship.linear_velocity.length()
		
		if(ship.docking_location != null and ship.docking_location is SpaceStation):
			factor = WarpTargetSpeed_Planet
		elif(p.isStar):
			factor = clamp(1 / v * WarpTargetSpeed_Sun * 1/g ,10,MaxtimeWarpFactor)
		elif(p.isPlanet):
			factor = clamp(1 / v * WarpTargetSpeed_Planet * p.radius/60.0 * 1/g,5,MaxtimeWarpFactor)	
		else:
			factor = clamp(1 / v * WarpTargetSpeed_Moon,5,MaxtimeWarpFactor)
			
		Engine.time_scale =  factor
		print(str(g) + " " + str(factor) + " x " + str(v) + " = " + str(factor * v))
	
	if Input.is_action_just_pressed("cheat_fuel"):
		Player.pay(ship.get_refule_costs()*2)
		ship.set_fuel(ship.fuel_cap)	
	
	if(Player.engine_fuel_left<= 0):
		call_deferred("_loadScore")		
	
	if(ship.hitpoints<=0):
		call_deferred("_loadScore")	
		
	if Input.is_action_just_pressed("quicksave"):
		_quicksave()
	
	if Input.is_action_just_pressed("quickload"):
		_quickload()
		
	if Input.is_action_just_pressed("toggel_names"):
		Globals.show_names = !Globals.show_names

	if Input.is_action_just_pressed("cheatCash"):
		Player.reward(100000)

	if Input.is_action_pressed("camera_turn_right"):
		$Camera._next_rotation.x += 3	
		print("right")
	if Input.is_action_pressed("camera_turn_left"):
		$Camera._next_rotation.x -= 3
		print("left")
	
	if Input.is_action_pressed("fire"):	
		ship.fire()		
		
	if Input.is_action_just_pressed("auto_orbit"):
		ship.autoCircle = !ship.autoCircle
		
	if Input.is_action_pressed("burn_forward"):
		ship.main_burn()
		if(ship.docking_location!=null):
			ship.undock()
	
	###Truster fire		
	if Input.is_action_pressed("burn_backward"):
		ship.lateral_burn(Vector2(-1,0))
		
	if Input.is_action_pressed("burn_lateral_left"):
		ship.lateral_burn(Vector2(0,-1))
	
	if Input.is_action_pressed("burn_lateral_right"):
		ship.lateral_burn(Vector2(0,1))	
		
	if Input.is_action_pressed("trun_left"):
		ship.rotational_trust = ship.turn_rate
		
	if Input.is_action_pressed("turn_right"):
		ship.rotational_trust = ship.turn_rate*-1

	if Input.is_action_just_pressed("info"):
		ship.toggelInfo()	
	
	

func _loadScore():
	var result = get_tree().change_scene_to_packed(SceneManager.endScreen)
	if(result==OK):	
		print("Game over")
	else:
		print("faild to load Scene!")

func _on_Ship_strongest_body_changed(old_body, new_body):
	#if(new_body!=null and new_body.name == "Sun"):
	#	#Temprary disable simulator
	#	$Simulator.on = true
	#	pass
	#else:
	#	$Simulator.on = false
	pass

func _on_Ship_docked(port):
	call_deferred("_quicksave")
	pass
	
func _on_Ship_undocked(port):
	call_deferred("_quicksave")
	pass

func _quicksave():
	if(loaded):
		save_game()	
		print("game Saved")
	
func _quickload():
	SceneManager.load_quicksave()

func save_game():
	#if($RotationShifter.SOIPlanet != null):
	#	$RotationShifter._unShift()
	
	var save_game = FileAccess.open(Globals.QUICKSAVE_PATH, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")	
	var dataList = []
	for node in save_nodes:

		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		var node_data = node.call("save")
		node_data["nodePath"] = node.get_path()
		dataList.append(node_data)

	dataList.append(Player.save())
	#Sort, so that parents come first in file.
	dataList.sort_custom(_sortNasedLast)
	
	for data in dataList:	
		var json = JSON.new()
		save_game.store_line(json.stringify(data))
	#save_game.close()

func _sortNasedLast(a,b):
	return a["parent"].get_name_count()<b["parent"].get_name_count()

func load_game():
	var json = JSON.new()
	loaded = false
	
	if not FileAccess.file_exists(Globals.QUICKSAVE_PATH):
		return # Error! We don't have a save to load.
	var save_game = FileAccess.open(Globals.QUICKSAVE_PATH, FileAccess.READ)
	#print(save_game.get_position())
	
	if(save_game.get_length()==0):
		print(Globals.QUICKSAVE_PATH + " is empty")
		
	Player.accepted_delivery_Missions = []
	while save_game.get_position() < save_game.get_length():
		var line = save_game.get_line()
		var error = json.parse(line)
		var node_data = json.get_data()
				
		if(node_data==null): 
			print(line)
			continue
		if(node_data["nodePath"]=="Player"):
			Player.load_save(node_data)
			continue
			
		if(node_data["nodePath"]=="/root/Sol/PlayerShip"):
			
			$PlayerShip.free()
			var laoded_PlayerShip :Ship = load(node_data["filename"]).instantiate()
			laoded_PlayerShip.freeze = false
			
			laoded_PlayerShip.playerControl = true			
			laoded_PlayerShip.name = "PlayerShip"
			var laoded_node_parent = get_node(node_data["parent"])
			laoded_node_parent.add_child(laoded_PlayerShip)	
			laoded_PlayerShip.load_save(node_data)	
			print("set Player Ship")
			self.setShip(laoded_PlayerShip)	
			continue
			
			
		var laoded_node = get_node_or_null(node_data["nodePath"])
		# Handel Dynamic Instanciation
		if(laoded_node==null):
			laoded_node = load(node_data["filename"]).instantiate()
			var laoded_node_parent = get_node(node_data["parent"])
			laoded_node_parent.add_child(laoded_node)
		laoded_node.load_save(node_data)


	loaded = true	
	save_game = null

func buyShip(newShip:Ship):
	if(!Player.credits>=newShip.price-ship.price):
		print("You miss: " + str((Player.credits-newShip.price+ship.price)*-1) + " Credits")
	else:
		var ShoppingTransform = newShip.transform
		var CurrentTransform = ship.transform
		var Shop = newShip.get_parent()
		
		#Move new Ship to correct position in Tree
		Shop.remove_child(newShip)
		self.add_child(newShip)
		newShip.owner = self
		if(ship.docking_location!=null):
			ship.undock()	
		
		#Copy Sate of Current Ship
		newShip.transform = CurrentTransform
		newShip.linear_velocity = ship.linear_velocity
		var cargo = ship.getListOfContainer()
		for c in cargo:
			if(newShip.can_load_container(1)):
				ship.unload_containter(c)
				var success = newShip.load_containter(c)
			else:
				ship.about_Container(c)			

		#Finances
		Player.reward(ship.price)
		Player.pay(newShip.price)
			
		#Deal With old Ship
		ship.playerControl = false	
		ship.freeze = true
		ship.free()
			
		#Activate New Ship	
		newShip.freeze = false
		newShip.playerControl =true
		newShip.name = "PlayerShip"
		
		self.setShip(newShip)

func _on_HUD_shipOrderd(ship):
	self.buyShip(ship)
