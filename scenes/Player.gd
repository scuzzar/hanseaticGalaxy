extends Node
var credits = 0
var max_engine_fuel = 50000
var engine_fuel_left = max_engine_fuel

var ship: Ship

var accepted_delivery_Missions = []

signal credits_changed(credits)

func _ready():
	self.add_to_group("persist")

func reward(reward_credits : int):
	credits +=reward_credits
	emit_signal("credits_changed",credits)
	
func pay(credits_to_pay : int):
	credits -= credits_to_pay
	emit_signal("credits_changed",credits)
	
func fuel_burned(amount):
	engine_fuel_left -= amount
	
func deliver_Container(m: DeliveryMission):	
	if(ship.docking_location == m.destination):
		self.reward(m.reward)
		ship.unload_containter(m.cargo)	
		var i = accepted_delivery_Missions.find(m)
		accepted_delivery_Missions.remove(i)
	else:
		print("container hit on Ship:" + m.destination.name)

func about_Container(m:DeliveryMission):
	ship.unload_containter(m.cargo)
	var i = accepted_delivery_Missions.find(m)
	accepted_delivery_Missions.remove(i)
	self.pay(m.reward* 0.2)

func accept_Mission(m:DeliveryMission):
	var docked = ship.docking_location != null
	var hasCargo = ship.docking_location.has_container(m.cargo)
	if(docked and hasCargo):		
		if(ship.can_load_container()):
			ship.docking_location.remove_Mission(m)
			ship.docking_location.remove_container(m.cargo)
			ship.load_containter(m.cargo)
			accepted_delivery_Missions.append(m)
		else:
			print("no Space on Ship")
	else:		
		print_debug("mission_accepted hit, but not executed!")

func get_accepted_delivery_Missions():
	return accepted_delivery_Missions

func save():
	var save_dict = {
		"nodePath" : "Player",
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),	
		"credits": credits,
		"max_engine_fuel" :max_engine_fuel,
		"engine_fuel_left" :engine_fuel_left
	}
	print(self.get_signal_connection_list("fuel_changed"))
	return save_dict

func load_save(dict):	
	credits = dict["credits"]
	max_engine_fuel = dict["max_engine_fuel"]
	engine_fuel_left = dict["engine_fuel_left"]
	emit_signal("credits_changed",credits)
