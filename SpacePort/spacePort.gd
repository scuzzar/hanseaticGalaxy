extends Spatial

class_name Port


var MissionContainerScene = preload("res://Container/Container.scn")

export(NodePath) var defaultMissionDestination_path
var _defaultMissionDestination :Port

var docked_ship: Ship

func _ready():	
	docked_ship = null
	#_defaultMissionDestination =  get_node_or_null(defaultMissionDestination_path)

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
	ship.pay(ship.get_refule_costs())
	ship.set_fuel(ship.fuel_cap)
	print_debug("ship landed")
	
func _on_Area_Ship_exited(ship : Ship):
	ship.undock()
	self.docked_ship = null
	print_debug("ship started")

func _on_container_clicked(container:MissionContainer):
	if($Inventory.hasContainer(container) and docked_ship != null):		
		if(docked_ship.can_load_container()):
			$Inventory.removeContainer(container)
			docked_ship.load_containter(container)
		else:
			print("no Space on Ship")
	else:
		print($Inventory.hasContainer(container) )
		print(docked_ship)
		print_debug("mission_accepted hit, but not executed!")

func add_container(c: MissionContainer):
	$Inventory.addContainerOnFree(c)

func has_Space() -> bool:
	return $Inventory.hasSpace()

func stock(cargo)->int:
	return $Inventory.stock(cargo)

func getBody()->Planet:
	return self.get_parent() as Planet
