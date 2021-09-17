extends Node
var credits = 0
var max_engine_fuel = 50000
var engine_fuel_left = max_engine_fuel

signal credits_changed(credits)

func reward(reward_credits : int):
	credits +=reward_credits
	emit_signal("credits_changed",credits)
	
func pay(credits_to_pay : int):
	credits -= credits_to_pay
	emit_signal("credits_changed",credits)
	
func fuel_burned(amount):
	engine_fuel_left -= amount
