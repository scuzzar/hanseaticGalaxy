extends Control

onready var fuel_bar = $Fuel/FuelBar
onready var dV_labe = $Fuel/VD
onready var live_bar = $Life/FuelBar
onready var credit_labe = $Credits/Value
onready var tmr_labe = $DataBox/TMR/Value
onready var g_labe = $DataBox/G_Meter/Value
onready var mass_labe = $DataBox/MASS/Value

#onready var v_labe = $DataBox/V_Meter/Value
#onready var v_cosmic = $DataBox/V_cosmic/Value
#onready var v_escape = $DataBox/V_escape/Value

onready var v_labe = $CenterHUB/V_Meter/Value
onready var v_cosmic = $CenterHUB/V_cosmic/Value
onready var v_escape = $CenterHUB/V_escape/Value

signal shipOrderd(ship)

var inShipShop=false

var ship_mass = 0
var strongest_body:simpelPlanet = null
var ship_position:Vector3
var ship:Ship
# Called when the node enters the scene tree for the first time.
func _ready():	
	Player.connect("credits_changed",self,"_on_credits_changed")
	$ShipShopButton.hide()
	credit_labe.text = str(Player.credits)	
	pass

func _process(delta):
	live_bar.value = int(Player.engine_fuel_left/Player.max_engine_fuel *100)
	pass

func setShip(ship:Ship):
	self.ship = ship
	ship_mass = ship.mass
	ship.connect("docked",self,"_on_Ship_docked")	
	ship.connect("fuel_changed",self,"_on_Ship_fuel_changed")
	ship.connect("g_force_update",self,"_on_Ship_g_force_update")
	ship.connect("mass_changed",self,"_on_Ship_mass_changed")
	ship.connect("telemetry_changed",self,"_on_Ship_telemetry_changed")
	ship.connect("undocked",self,"_on_Ship_undocked")	
	_on_Ship_fuel_changed(ship.fuel,ship.fuel_cap)

func _on_Ship_fuel_changed(fuel,fuel_cap):
	var dV = fuel / ship.mass
	dV_labe.text = str("%0.1f" %  dV) + " dV"
	fuel_bar.value = int(fuel / fuel_cap *100)
	#fuel_bar.value = fuel / ship.mass


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
	if(strongest_body != null):
		velocety -= strongest_body.linear_velocity
		
		var r = strongest_body.global_transform.origin.distance_to(ship_position)
		var G = Globals.G
		var M = strongest_body.mass
		var kosmic = sqrt(G*M/r)
		var escape = kosmic * sqrt(2)
		
		v_labe.text = str("%0.1f" % (velocety.length())) 
		v_cosmic.text = str("%0.1f" % kosmic) 
		v_escape.text = str("%0.1f" % escape)


func _on_Ship_docked(port:Port):
	$InventoryWindow.setPort(port)
	$CenterHUB.hide()
	$DataBox.hide()
	$CargoBay.show()
	if(!port.getShipsForSale().empty()):
		$ShipShopButton.show()
		$ShipShop.setWarft(port)
	else:
		$ShipShopButton.hide()
		

func _on_Ship_undocked(port:Port):
	$InventoryWindow.clearPort(port)
	$CenterHUB.show()
	$DataBox.show()
	$CargoBay.hide()
	$ShipShopButton.hide()
	$ShipShop.hide()
	inShipShop = false

func _on_InventoryWindow_accepted(container):
	ship.docking_location.accept_Mission(container)
	$CargoBay.update()
	
func _on_CargoBay_deliver(container):
	ship.deliver_Container(container)
	$CargoBay.update()

func _on_CargoBay_about(container):
	ship.about_Container(container)
	$CargoBay.update()
	$InventoryWindow.update()


func _on_Button_pressed():
	if(!inShipShop):
		$CargoBay.hide()
		$InventoryWindow.hide()
		$ShipShop.show()
		self.inShipShop=true
	else:
		$CargoBay.show()
		$InventoryWindow.show()
		$ShipShop.hide()
		self.inShipShop=false


func _on_shipOrderd(ship):
	self.emit_signal("shipOrderd",ship)
	if($ShipShop.warft.getShipsForSale().empty()):
		_on_Button_pressed()
		$ShipShopButton.hide()
