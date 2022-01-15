extends Panel

onready var slider:HSlider = $Grid/Refuel
onready var price_lable:Label =$Grid/Price
onready var sum:Label =$Grid/Sum
onready var amount_lable:Label =$Grid/amount
onready var mass_lable:Label =$Grid/mass

signal refuel_cart_change(amount)

var ship:Ship
var price:int

func setShip(ship:Ship):
	self.ship = ship
	var port :Port = ship.docking_location	
	price = port.fuel_price
	price_lable.text = str(price)
	var max_refuel = ship.fuel_cap -ship.fuel
	slider.min_value = 0
	slider.max_value = max_refuel
	slider.value = max_refuel
	


func _on_Refuel_Button_pressed():	
	var refuel_cost = int(sum.text)
	var amount = slider.value
	if(!Player.credits>refuel_cost):
		amount = int(Player.credits/refuel_cost*amount)
		refuel_cost = amount * price
	Player.pay(refuel_cost)		
	ship.set_fuel(ship.fuel + amount)
	self.setShip(ship)

func _on_Refuel_value_changed(value):
	var intValue = int(value)
	sum.text = str(intValue*price)
	amount_lable.text = str(intValue)
	mass_lable.text = str(intValue*Globals.get_fuel_mass())
	emit_signal("refuel_cart_change",intValue)
