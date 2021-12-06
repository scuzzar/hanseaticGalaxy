extends Node

export(MissionContainer.CARGO) var cargo
#onready var cargoName = MissionContainer.new().names[cargo]
export(float) var wait_time = 10
export(int) var max_store = 100
export(int) var init_store = 1

const groupTag = "TARGET"

onready var port:Port = self.get_parent()
var MissionContainerScene = preload("res://Container/Container.scn")

func _ready():		
	$GenTimer.wait_time = self.wait_time	
	$GenTimer.start()

func generateInitialStock():
	for i in init_store : port.add_container(self._generate_mission())

func _on_GenTimer_timeout():	
	if(port.has_Space() and port.stock(cargo)<max_store):
		var c = _generate_mission()
		port.add_container(c)
		


func _generate_mission() -> MissionContainer:
	var c = MissionContainerScene.instance()
	c.origin = port
	c.destination = self._select_destination()	
	c._set_cargo(cargo)	
	var distance = c.getDistance()	
	c.reward = round(c.getPrice() * sqrt(distance)*12/30)
	#print_debug(port.name + " > ",str(c))
	return c

func _select_destination()->Port:
	var target:CargoTarget 	
	var possibleTargets = self.get_tree().get_nodes_in_group(groupTag+str(cargo))	
	if(possibleTargets.size()>0):
		#print()
		#print(port.name + " " + groupTag+str(cargo))
		#for t in possibleTargets : print(t.get_Port().name)
		
		target = possibleTargets[randi()%possibleTargets.size()]
		return target.get_Port()
	else:
		return port.get_default_location() 
	


	
	
	
	
	
