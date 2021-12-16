extends Spatial

var endScreen = preload("res://scenes/GameEnded/EndGameScreen.tscn")
#var loader : ResourceInteractiveLoader
onready var ship:Ship = $PlayerShip
onready var all = self.get_children()
export var MaxtimeWarpFactor = 400

func _ready():
	setShip(ship)	
	if(Globals.loadPath !=null):
		self.load_game()
	else:
		newGameSetup()

func newGameSetup():
	for cg in get_tree().get_nodes_in_group("cargoGenerator"):
		cg.generateInitialStock()

func setShip(newShip:Ship):
	newShip.connect("strongest_body_changed",self,"_on_Ship_strongest_body_changed")
	newShip.connect("soiPlanetChanged",$RotationShifter,"on_soi_planet_changed")
	$HUD.setShip(newShip)
	$HUD/InventoryWindow.setShip(newShip)
	$HUD/CargoBay.ship = newShip
	$Camera.ship =newShip
	$Simulator._simulation_Object = newShip
	self.ship = newShip
	$Shifter.parent = newShip

func _process(delta):
	if Input.is_action_pressed("endGame"):
		print("you ended the game!")
		call_deferred("_loadScore")
	
	Engine.time_scale =  1
	
	if Input.is_action_pressed("time_delay"):
		var factor = clamp(1 / ship.last_g_force.length()*ship.mass,0.001,0.001)
		Engine.time_scale =  factor
	
	if Input.is_action_pressed("time_warp"):
		var factor = clamp(1 / ship.last_g_force.length()*200,5,MaxtimeWarpFactor)
		Engine.time_scale =  factor
	
	if Input.is_action_just_pressed("cheat_fuel"):
		Player.pay(ship.get_refule_costs()*2)
		ship.set_fuel(ship.fuel_cap)	
	
	if(Player.engine_fuel_left<= 0):
		call_deferred("_loadScore")		
	
	if Input.is_action_just_pressed("quicksave"):
		_quicksave()
	
	if Input.is_action_just_pressed("quickload"):
		_quickload()

	if Input.is_action_just_pressed("cheatCash"):
		Player.reward(100000)

	if Input.is_action_pressed("camera_turn_right"):
		$Camera._next_rotation.x += 3	
		print("right")
	if Input.is_action_pressed("camera_turn_left"):
		$Camera._next_rotation.x -= 3
		print("left")

func _loadScore():
	var result = get_tree().change_scene_to(endScreen)
	if(result==OK):	
		print("Game over")
	else:
		print("faild to load Scene!")

func _on_Ship_strongest_body_changed(old_body, new_body):
	if(new_body!=null and new_body.name == "Sun"):
		#Temprary disable simulator
		#$Simulator.on = true
		pass
	else:
		$Simulator.on = false

func _quicksave():
	save_game()	
	print("game Saved")
	
func _quickload():
	Globals.loadPath = Globals.QUICKSAVE_PATH
	self.get_tree().reload_current_scene()

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
			#var docking_location = ship.docking_location
			#var docking_location = ship.docking_location
			ship.undock()
			#newShip.dock(docking_location)
		
		
		#Copy Sate of Current Ship
		newShip.transform = CurrentTransform
		newShip.linear_velocity = ship.linear_velocity
		var cargo = ship.getListOfContainer()
		for c in cargo:
			if(newShip.can_load_container()):
				ship.unload_containter(c)
				var success = newShip.load_containter(c)
			else:
				ship.about_Container(c)			
		

		
		#Finances
		Player.reward(ship.price)
		Player.pay(newShip.price)
			
		#Deal With old Ship
		ship.playerControl = false	
		ship.physikAktiv = false
		ship.free()
			
			
		#Activate New Ship	
		newShip.physikAktiv = true
		newShip.playerControl =true
		newShip.name = "PlayerShip"
		
		self.setShip(newShip)
	


func load_game():
	var save_game = File.new()
	if not save_game.file_exists(Globals.QUICKSAVE_PATH):
		return # Error! We don't have a save to load.

	save_game.open(Globals.QUICKSAVE_PATH, File.READ)
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
			laoded_PlayerShip.physikAktiv = true
			laoded_PlayerShip.load_save(node_data)
			laoded_PlayerShip.playerControl = true			
			laoded_PlayerShip.name = "PlayerShip"
			var laoded_node_parent = get_node(node_data["parent"])
			laoded_node_parent.add_child(laoded_PlayerShip)			
			self.setShip(laoded_PlayerShip)
			continue
			
			
		var laoded_node = get_node_or_null(node_data["nodePath"])
		# Handel Dynamic Instanciation
		if(laoded_node==null):
			laoded_node = load(node_data["filename"]).instance()
			var laoded_node_parent = get_node(node_data["parent"])
			laoded_node_parent.add_child(laoded_node)
		laoded_node.load_save(node_data)

	save_game.close()
	
func _on_HUD_shipOrderd(ship):
	self.buyShip(ship)
