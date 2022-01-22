extends Spatial


#var loader : ResourceInteractiveLoader
onready var ship:Ship = $PlayerShip
onready var all = self.get_children()
export var MaxtimeWarpFactor = 400
export var MaxtimeWarpFactor_Planet = 50
export var MaxtimeWarpFactor_Moon = 5

export(NodePath) var player_spawn_point_path = "Sun/Earth/BrasiliaPort"
onready var player_spawn_point:Port = get_node_or_null(player_spawn_point_path)

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
	ship.fuel = 0
	Player.credits = 10000
	if(player_spawn_point!=null):			
		ship.transform = player_spawn_point.get_docking_globaltransform()
		var spawn_body :simpelPlanet = player_spawn_point.getBody()
		print("BodyVal" + str(spawn_body.linear_velocity) + " abs " +str(spawn_body.linear_velocity.length()))
		var offset_vel = spawn_body.linear_velocity
		if(!spawn_body.isPlanet):
			offset_vel += spawn_body.get_parent().linear_velocity
		ship.write_linear_velocity(offset_vel)# spawn_body.linear_velocity
		
		
	ship.physicActiv =true
	loaded = true	

func setShip(newShip):
	newShip.connect("strongest_body_changed",self,"_on_Ship_strongest_body_changed")
	newShip.connect("soiPlanetChanged",$RotationShifter,"on_soi_planet_changed")
	newShip.connect("docked",self,"_on_Ship_docked")
	newShip.connect("undocked",self,"_on_Ship_undocked")
	$HUD.setShip(newShip)
	$HUD/DeliveryBoard.setShip(newShip)
	$HUD/DeliveryMissionOverview.ship = newShip
	$Camera.ship =newShip
	$Simulator._simulation_Object = newShip
	self.ship = newShip
	$Shifter.parent = newShip
	Player.ship = newShip
	newShip.team = ENUMS.TEAM.PLAYER

func _process(delta):
	if(! is_instance_valid(ship)):return
	
	if Input.is_action_just_pressed("debug_state"):
		print(str(ship.transform.origin) + " + " +  str(ship.linear_velocity))
	
	if Input.is_action_pressed("endGame"):
		print("you ended the game!")
		call_deferred("_loadScore")
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	Engine.time_scale =  1
	
	if Input.is_action_pressed("time_delay"):
		var factor = clamp(1 / ship.last_g_force.length()*ship.mass,0.001,0.001)
		Engine.time_scale =  factor
	
	if Input.is_action_pressed("time_warp"):
		
		var p = ship.last_g_force_strongest_Body as simpelPlanet
		var factor = 1
		
		if(ship.docking_location != null and ship.docking_location is SpaceStation):
			factor = 50
		elif(p.isStar):
			 factor = clamp(1 / ship.last_g_force.length()*200,5,MaxtimeWarpFactor)
		elif(p.isPlanet):
			factor = clamp(1 / ship.last_g_force.length()*p.radius/2,5,MaxtimeWarpFactor_Planet)	
		else:
			factor = MaxtimeWarpFactor_Moon
			
		Engine.time_scale =  factor
	
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
	var result = get_tree().change_scene_to(SceneManager.endScreen)
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
	var save_game = File.new()
	save_game.open(Globals.QUICKSAVE_PATH, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")	
	var dataList = []
	for node in save_nodes:

		if node.filename.empty():
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
	dataList.sort_custom(self,"_sortNasedLast")
	
	for data in dataList:	
		save_game.store_line(to_json(data))
	save_game.close()

func _sortNasedLast(a,b):
	return a["parent"].get_name_count()<b["parent"].get_name_count()

func load_game():
	loaded = false
	var save_game = File.new()
	if not save_game.file_exists(Globals.QUICKSAVE_PATH):
		return # Error! We don't have a save to load.

	save_game.open(Globals.QUICKSAVE_PATH, File.READ)
	print(save_game.get_position())
	
	if(save_game.get_len()==0):
		print(Globals.QUICKSAVE_PATH + " is empty")
	while save_game.get_position() < save_game.get_len():
		var line = save_game.get_line()
		var node_data = parse_json(line)
		if(node_data==null): 
			print(line)
			continue
		if(node_data["nodePath"]=="Player"):
			Player.load_save(node_data)
			continue
			
		if(node_data["nodePath"]=="/root/Sol/PlayerShip"):
			$PlayerShip.free()
			var laoded_PlayerShip :Ship = load(node_data["filename"]).instance()
			laoded_PlayerShip.physicActiv = true
			
			laoded_PlayerShip.playerControl = true			
			laoded_PlayerShip.name = "PlayerShip"
			var laoded_node_parent = get_node(node_data["parent"])
			laoded_node_parent.add_child(laoded_PlayerShip)	
			laoded_PlayerShip.load_save(node_data)	
			self.setShip(laoded_PlayerShip)
			continue
			
			
		var laoded_node = get_node_or_null(node_data["nodePath"])
		# Handel Dynamic Instanciation
		if(laoded_node==null):
			laoded_node = load(node_data["filename"]).instance()
			var laoded_node_parent = get_node(node_data["parent"])
			laoded_node_parent.add_child(laoded_node)
		laoded_node.load_save(node_data)

	loaded = true
	save_game.close()

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
		ship.physicActiv = false
		ship.free()
			
		#Activate New Ship	
		newShip.physicActiv = true
		newShip.playerControl =true
		newShip.name = "PlayerShip"
		
		self.setShip(newShip)

func _on_HUD_shipOrderd(ship):
	self.buyShip(ship)
