extends Control

var ship : Ship

onready var fuel_bar = $Fuel/FuelBar
onready var credit_labe = $Credits/HSplitContainer/Value
func _enter_tree():
	ship = $"../Ship"

# Called when the node enters the scene tree for the first time.
func _ready():	
	pass

func _process(delta):
	#$Fuel.text = String(ship.fuel)
	pass

func _on_Ship_fuel_changed(fuel):
	#fuel_label.text = String(round(fuel))
	fuel_bar.value = int(fuel / ship.fuel_cap *100)


func _on_Ship_credits_changed(credits):
	credit_labe.text = str(credits)
