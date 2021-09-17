extends Control

onready var fuel_bar = $Fuel/FuelBar
onready var live_bar = $Life/FuelBar
onready var credit_labe = $Credits/Value
onready var tmr_labe = $DataBox/TMR/Value
onready var g_labe = $DataBox/G_Meter/Value
onready var mass_labe = $DataBox/MASS/Value
onready var v_labe = $DataBox/V_Meter/Value

var ship_mass = 0
var strongest_body:simpelPlanet = null
var ship_position:Vector3

# Called when the node enters the scene tree for the first time.
func _ready():	
	Player.connect("credits_changed",self,"_on_credits_changed")
	pass

func _process(delta):
	live_bar.value = int(Player.engine_fuel_left/Player.max_engine_fuel *100)
	pass

func _on_Ship_fuel_changed(fuel,fuel_cap):
	#fuel_label.text = String(round(fuel))
	fuel_bar.value = int(fuel / fuel_cap *100)


func _on_credits_changed(credits):
	credit_labe.text = str(credits)


func _on_Ship_mass_changed(mass, trust):
	ship_mass = mass
	mass_labe.text = str(mass)
	tmr_labe.text = str("%0.2f" % (trust/mass))


func _on_Ship_g_force_update(force,p_stronges_body,strongest_force):
	self.strongest_body = p_stronges_body as simpelPlanet
	g_labe.text = str("%0.2f" % (force.length()/ship_mass)) + " (" + strongest_body.name + ")"	

func _on_Ship_telemetry_changed(position,velocety):
	self.ship_position = position
	velocety -= strongest_body.linear_velocity
	
	var r = strongest_body.global_transform.origin.distance_to(ship_position)
	var G = 50
	var M = strongest_body.mass
	var kosmic = sqrt(G*M/r)
	
	v_labe.text = str("%0.1f" % (velocety.length())) + "  cosmic:" + str("%0.1f" % kosmic)
