extends Spatial

class_name Port


var MissionContainerScene = preload("res://Station/Container.scn")

export(NodePath) var defaultMissionDestination_path
var defaultMissionDestination :Node

var docked_ship: Ship

func _ready():	
	docked_ship = null
	self._generate_mission()
	self._generate_mission()

func _generate_mission():
	var c = MissionContainerScene.instance()
	defaultMissionDestination =  get_node_or_null(defaultMissionDestination_path)
	c.destination = defaultMissionDestination	
	#print(self.name + " d_dest:" + defaultMissionDestination.name)	
	$Inventory.addContainerOnFree(c)

func _on_Area_body_entered(body):
	if(body is Ship):		
		self._on_Area_Ship_enterd(body)

func _on_Area_body_exited(body):
	if(body is Ship):		
		self._on_Area_Ship_exited(body)

func _on_Area_Ship_enterd(ship : Ship):
	ship.dock(self)
	self.docked_ship = ship
	ship.set_fuel(ship.fuel_cap)
	print("ship landed")
	
func _on_Area_Ship_exited(ship : Ship):
	ship.undock()
	self.docked_ship = null
	print("ship started")

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



