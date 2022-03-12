extends Node3D

class_name Port

@export
var defaultMissionDestination_path: NodePath

var _defaultMissionDestination :Port
@onready 
var inventory = $Inventory
var docked_ship: Ship
var delivery_Missions = []

var fuel_price = 0

func _ready():	
	docked_ship = null
	$Lable3D.text = name
	fuel_price = Globals.get_fuel_base_price()

func get_default_location()->Port:
	if(_defaultMissionDestination==null):
		_defaultMissionDestination =  get_node_or_null(defaultMissionDestination_path)
	return _defaultMissionDestination

func _on_Area_body_entered(body):
	if(body is Ship):		
		self._on_Area_Ship_enterd(body)

func _on_Area_body_exited(body):
	if(body is Ship):		
		self._on_Area_Ship_exited(body)

func _on_Area_Ship_enterd(ship : Ship):
	ship.dock(self)
	self.docked_ship = ship
	#_refuel(ship)
	_repair(ship)

func _refuel(ship : Ship):
	Player.pay(ship.get_refule_costs())		
	ship.set_fuel(ship.fuel_cap)
	
func _repair(ship:Ship):
	var damage = ship.max_hitpoints-ship.hitpoints
	ship.hitpoints = ship.max_hitpoints
	Player.pay(damage*35)

func _on_Area_Ship_exited(ship : Ship):
	ship.undock()
	self.docked_ship = null	

func getShipsForSale():
	var result = []
	for c in self.get_children():
		if c is Ship :
			result.append(c)
	return result

func add_Mission(mission:Mission):
	if(mission is DeliveryMission):
		delivery_Missions.append(mission)
		self.add_child(mission)	

func remove_Mission(mission:Mission):
	if(mission is DeliveryMission):
		var i = delivery_Missions.find(mission)
		delivery_Missions.remove(i)
		self.remove_child(mission)
		
func get_all_DeliveryMissions():
	return delivery_Missions


func has_Mission(mission:Mission):
	if(mission is DeliveryMission):
		return delivery_Missions.has(mission)
	else:
		return false

func has_container(c: CargoContainer):
	return $Inventory.hasContainer(c)

func add_container(c: CargoContainer):
	$Inventory.addContainerOnFree(c)

func add_all_Container(ContainerArray):
	$Inventory.addAllContainerOnFree(ContainerArray)

func remove_container(c: CargoContainer):
	$Inventory.removeContainer(c)

func remove_all_container(ContainerArray):
	$Inventory.remove_all_container(ContainerArray)

func has_Space() -> bool:
	return $Inventory.hasSpace()

func freeSpace() -> int:
	return $Inventory.freeSpace()

func stock(cargo)->int:
	return $Inventory.stock(cargo)

func getBody()->simpelPlanet:
	return self.get_parent() as simpelPlanet

func get_docking_globaltransform():
	return $DockingLocation.global_transform
