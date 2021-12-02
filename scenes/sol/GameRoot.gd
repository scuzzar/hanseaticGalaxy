extends Spatial

var endScreen = preload("res://scenes/GameEnded/EndGameScreen.tscn")
#var loader : ResourceInteractiveLoader
onready var ship = $Ship

export var MaxtimeWarpFactor = 200

func _ready():
	setShip(ship)
	if(Globals.loadPath !=null):
		self.load_game()
	else:
		generateInitialCargo()
	
func setShip(ship:Ship):
	ship.connect("strongest_body_changed",self,"_on_Ship_strongest_body_changed")
	$HUD.setShip(ship)
	$HUD/InventoryWindow.setShip(ship)
	$HUD/CargoBay.ship = ship

func generateInitialCargo():
	for cg in get_tree().get_nodes_in_group("cargoGenerator"):
		cg.generateInitialStock()

func _process(delta):
	if Input.is_action_pressed("endGame"):	
		print("you ended the game!")	
		call_deferred("_loadScore")		
		
	if Input.is_action_pressed("time_delay"):	
		var factor = clamp(1 / ship.last_g_force.length()*ship.mass,0.001,0.001)		
		call_deferred("setTimeScale",factor)
	if Input.is_action_pressed("time_warp"):		
		var factor = clamp(1 / ship.last_g_force.length()*ship.mass,5,MaxtimeWarpFactor)		
		call_deferred("setTimeScale",factor)
	
	if Input.is_action_just_pressed("cheat_fuel"):
		Player.pay(ship.get_refule_costs()*2)
		ship.set_fuel(ship.fuel_cap)	
		
	if(Player.engine_fuel_left<= 0):
		call_deferred("_loadScore")		
	
	if Input.is_action_just_pressed("quicksave"):
		_quicksave()
		
	if Input.is_action_just_pressed("quickload"):
		_quickload()

func _loadScore():
	var result = get_tree().change_scene_to(endScreen)
	if(result==OK):	
		print("Game over")
	else:
		print("faild to load Scene!")

func setTimeScale(factor):
	Engine.time_scale =  factor

func _on_Ship_strongest_body_changed(old_body, new_body):
	if(new_body.name == "Sun"):
		$Simulator.on = true
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

func load_game():
	var all = self.get_children()
	var save_game = File.new()
	if not save_game.file_exists(Globals.QUICKSAVE_PATH):
		return # Error! We don't have a save to load.

	save_game.open(Globals.QUICKSAVE_PATH, File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		if(node_data["nodePath"]=="Player"):
			Player.load_save(node_data)
			continue
		var laoded_node = get_node_or_null(node_data["nodePath"])
		# Handel Dynamic Instanciation
		if(laoded_node==null):
			laoded_node = load(node_data["filename"]).instance()
			get_node(node_data["parent"]).add_child(laoded_node)
		laoded_node.load_save(node_data)

	save_game.close()
	all = self.get_children()

