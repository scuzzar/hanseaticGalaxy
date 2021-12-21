extends Node

export(CargoContainer.CARGO) var cargo
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
	for i in init_store : 
		var mission = self._generate_mission()
		port.add_Mission(mission)
		port.add_container(mission.cargo)

func _on_GenTimer_timeout():	
	if(port.has_Space() and port.stock(cargo)<max_store):
		var mission = _generate_mission()
		port.add_Mission(mission)
		port.add_container(mission.cargo)
		


func _generate_mission() -> DeliveryMission:
	
	var origin = port
	var destination = self._select_destination()	
	var mission = DeliveryMission.new(origin,destination)
	
	var c = MissionContainerScene.instance()
	c._set_cargo(cargo)	
	
	mission.cargo = c
	
	var distance = mission.getDistance()	
	mission.reward = round(mission.getPrice() * log(distance)*log(distance)/5)
	return mission

func _select_destination()->Port:
	var target:CargoTarget 	
	var possibleTargets = self.get_tree().get_nodes_in_group(groupTag+str(cargo))	
	var i = possibleTargets.find(port)
	if(i != -1):
		possibleTargets.remove(i)
	if(possibleTargets.size()>0):
		target = possibleTargets[randi()%possibleTargets.size()]
		return target.get_Port()
	else:
		return port.get_default_location() 
	


	
	
	
	
	
