extends Node
var credits = 0
var max_engine_fuel = 50000
var engine_fuel_left = max_engine_fuel

var ship: Ship

var accepted_delivery_Missions = []

signal credits_changed(credits)
signal mission_accepted(mission)
signal mission_about(mission)

func _ready():
	self.add_to_group("persist")
	self.mission_accepted.connect(Pirates.on_mission_accepted)
	self.mission_about.connect(Pirates.on_mission_about)	

func reward(reward_credits : int):
	credits +=reward_credits
	emit_signal("credits_changed",credits)
	
func pay(credits_to_pay : int):
	credits -= credits_to_pay
	emit_signal("credits_changed",credits)
	
func fuel_burned(amount):
	#engine_fuel_left -= amount
	pass
func deliver_Mission(m: DeliveryMission):	
	if(ship.docking_location == m.destination):
		self.reward(m.reward)
		ship.unload_all_container(m.cargoContainer)	
		var i = accepted_delivery_Missions.find(m)
		accepted_delivery_Missions.remove(i)
		ship.remove_child(m)
	else:
		print("container hit on Ship:" + m.destination.name)

func about_Mission(m:DeliveryMission):
	ship.unload_all_container(m.cargoContainer)
	var i = accepted_delivery_Missions.find(m)	
	accepted_delivery_Missions.remove(i)	
	ship.remove_child(m)
	self.pay(m.reward* 0.2)
	emit_signal("mission_about",m)
	m.emit_signal("aborted")

func accept_Mission(m:DeliveryMission):
	var docked = ship.docking_location != null
	if(docked):		
		if(ship.can_load_container(m.getContainerCount())):
			ship.docking_location.remove_Mission(m)
			ship.docking_location.remove_all_container(m.cargoContainer)
			ship.load_all_container(m.cargoContainer)
			accepted_delivery_Missions.append(m)
			ship.add_child(m)
			m.accepted = true
			emit_signal("mission_accepted",m)
		else:
			print("no Space on Ship")
	else:		
		print_debug("mission_accepted hit, but not executed!")

func get_accepted_delivery_Missions():
	return accepted_delivery_Missions

func save():
	var save_dict = {
		"nodePath" : "Player",
		"filename" : scene_file_path,
		"parent" : get_parent().get_path(),	
		"credits": credits,
		"max_engine_fuel" :max_engine_fuel,
		"engine_fuel_left" :engine_fuel_left
	}
	print(self.get_signal_connection_list("fuel_changed"))
	return save_dict

func load_save(dict):	
	self.accepted_delivery_Missions = []
	credits = dict["credits"]
	max_engine_fuel = dict["max_engine_fuel"]
	engine_fuel_left = dict["engine_fuel_left"]
	emit_signal("credits_changed",credits)
