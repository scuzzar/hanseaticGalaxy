extends Control



onready var fuel_bar = $Fuel/FuelBar
onready var credit_labe = $Credits/Value
onready var tmr_labe = $DataBox/TMR/Value
onready var g_labe = $DataBox/G_Meter/Value
onready var mass_labe = $DataBox/MASS/Value
onready var v_labe = $DataBox/V_Meter/Value

var ship_mass = 0

# Called when the node enters the scene tree for the first time.
func _ready():	
	pass

func _process(delta):
	#$Fuel.text = String(ship.fuel)
	pass

func _on_Ship_fuel_changed(fuel,fuel_cap):
	#fuel_label.text = String(round(fuel))
	fuel_bar.value = int(fuel / fuel_cap *100)


func _on_Ship_credits_changed(credits):
	credit_labe.text = str(credits)


func _on_Ship_mass_changed(mass, trust):
	ship_mass = mass
	mass_labe.text = str(mass)
	tmr_labe.text = str("%0.2f" % (trust/mass))


func _on_Ship_g_force_update(force):
	g_labe.text = str("%0.2f" % (force.length()/ship_mass))


func _on_Ship_velocety_changed(velocety):
	v_labe.text = str("%0.2f" % (velocety.length()))
