extends Node
var credits = 0
var max_engine_fuel = 50000
var engine_fuel_left = max_engine_fuel

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
