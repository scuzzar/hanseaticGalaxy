extends Node

export(CargoContainer.CARGO) var cargo = CargoContainer.CARGO.NONE
export(int) var max_missions = 3
export(int) var init_missions = 2

const groupTag = "TARGET"

onready var port:Port = self.get_Port()
var deliveryMissionScene = preload("res://Mission/Delivery/DeliveryMission.tscn")

const ContainerTyp = preload("res://Cargo/containerTyps.csv").records

func _ready():
	port = 	self.get_Port()
	if(cargo!=CargoContainer.CARGO.NONE):
		$GenTimer.wait_time = self.getProductionTime()*60
		$GenTimer.start()

func generateInitialStock():
	if(cargo!=CargoContainer.CARGO.NONE):	 
		for i in init_missions : 
			var mission = self._generate_mission()
			if(mission!=null):
				port.add_Mission(mission)
				port.add_all_Container(mission.cargoContainer)

func _on_GenTimer_timeout():	
	if(port.freeSpace()>self.getMaxBatch() and port.stock(cargo)<max_missions*self.getMaxBatch()):
		var mission = _generate_mission()
		if(mission!=null):
			port.add_Mission(mission)		
			port.add_all_Container(mission.cargoContainer)
		


func _generate_mission() -> DeliveryMission:	
	var origin = port
	var destination = self._select_destination()
	if(destination ==null):
		print_debug("No destination for " + str(cargo) + " from " + str(origin))
		return null
	var mission = deliveryMissionScene.instance()
	mission.origin = origin
	mission.destination = destination
	mission.cargo = cargo
	
	var amount = self.getMinBatch()
	var maxAddition = self.getMaxBatch() - amount	
	if maxAddition>0 : amount += randi()%maxAddition
	
	mission._createContainer(amount)
	
	var distance = mission.getDistance()
	var single_reward=round(mission.getPrice() * log(distance)*log(distance)/5)
	mission.reward = single_reward * amount
	return mission

func _select_destination()->Port:
	var targetPort:Port 	
	var possibleTargets = self.get_tree().get_nodes_in_group(groupTag+str(cargo))
	var possiblePorts = []
	for t in possibleTargets:possiblePorts.append(t.get_Port())
	while(possiblePorts.has(port)): possiblePorts.erase(port)
	if(possiblePorts.size()>0):
		targetPort = possiblePorts[randi()%possiblePorts.size()]
		return targetPort
	else:
		return null
	
func getProductionTime():
	return ContainerTyp[cargo]["productionTime"]
	
func getMinBatch():
	return ContainerTyp[cargo]["minBatch"]
	
func getMaxBatch():
	return ContainerTyp[cargo]["maxBatch"]

func get_Port()->Port:
	if(self.get_parent() is Port):
		return self.get_parent() as Port
	elif(self.get_parent().get_parent() is Port):
			return self.get_parent().get_parent()  as Port
	
	elif(self.get_parent().get_parent().get_child_count()>0):
		return self.get_parent().get_parent().get_child(0) as Port
	else:
		print_debug("no Port")
		return null
