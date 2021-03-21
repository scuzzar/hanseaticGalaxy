extends Spatial

class_name Port

onready var slots = [$slot1,$slot2,$slot3,$slot4]
var MissionContainerScene = preload("res://Station/Container.scn")

export(NodePath) var defaultMissionDestination_path
var defaultMissionDestination :Node

var docked_ship: Ship

func _ready():	
	docked_ship = null
	self._generate_mission()	

func _generate_mission():
	var c = MissionContainerScene.instance()
	defaultMissionDestination =  get_node_or_null(defaultMissionDestination_path)
	c.destination = defaultMissionDestination	
	print(self.name + " d_dest:" + defaultMissionDestination.name)
	self.addContainter(c,0)

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

func addContainter(container:MissionContainer, i : int):
	var slot = slots[i] as Position3D
	assert(slot.get_child_count()==0)
	slot.add_child(container)
	container.connect("clicked",self,"_on_container_clicked")
	container.translation = Vector3(0,0,0)
	
func getContainer(i : int) -> MissionContainer:
	var slot = slots[i] as Position3D
	assert(slot.get_child_count()==1)	
	return slot.get_child(0)

func hasContainer(container:MissionContainer) -> bool:
	for slot in slots:
		if(slot.get_child_count() == 1 and slot.get_child(0)==container):			
			return true
	return false

func removeContainer(container:MissionContainer) -> bool :	
	for slot in slots:
		if(slot.get_child_count() == 1 and slot.get_child(0)==container):
			slot.remove_child(container)
			return true
	return false

func _on_container_clicked(container:MissionContainer):
	if(self.hasContainer(container) and docked_ship != null):		
		self.removeContainer(container)
		docked_ship.load_containter(container)
		container.disconnect("clicked",self,"_on_container_clicked")		
	else:
		print(self.hasContainer(container) )
		print(docked_ship)
		print_debug("mission_accepted hit, but not executed!")



