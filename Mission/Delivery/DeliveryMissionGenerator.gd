extends Node

export(CargoContainer.CARGO) var cargo = CargoContainer.CARGO.NONE
export(int) var max_missions = 3
export(int) var init_missions = 1

const groupTag = "TARGET"

onready var port:Port = self.get_parent()
var deliveryMissionScene = preload("res://Mission/Delivery/DeliveryMission.tscn")

const ContainerTyp = preload("res://Cargo/containerTyps.csv").records

func _ready():		
	if(cargo!=CargoContainer.CARGO.NONE):
		$GenTimer.wait_time = self.getProductionTime()*60
		$GenTimer.start()

func generateInitialStock():
	if(cargo!=CargoContainer.CARGO.NONE):	 
		for i in init_missions : 
			var mission = self._generate_mission()
			port.add_Mission(mission)
			port.add_all_Container(mission.cargoContainer)

func _on_GenTimer_timeout():	
	if(port.freeSpace()>self.getMaxBatch() and port.stock(cargo)<max_missions*self.getMaxBatch()):
		var mission = _generate_mission()
		port.add_Mission(mission)		
		port.add_all_Container(mission.cargoContainer)
		


func _generate_mission() -> DeliveryMission:	
	var origin = port
	var destination = self._select_destination()	
	var mission = deliveryMissionScene.instance()
	mission.origin = origin
	mission.destination = destination
	mission.cargo = cargo
	
	var amount = self.getMinBatch()
	var maxAddition = self.getMaxBatch() - amount	
	amount += randi()%maxAddition
	
	mission._createContainer(amount)
	
	var distance = mission.getDistance()	
	mission.reward = round(mission.getPrice() * log(distance)*log(distance)/5) * amount
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
	
func getProductionTime():
	return ContainerTyp[cargo]["productionTime"]
	
func getMinBatch():
	return ContainerTyp[cargo]["minBatch"]
	
func getMaxBatch():
	return ContainerTyp[cargo]["maxBatch"]
