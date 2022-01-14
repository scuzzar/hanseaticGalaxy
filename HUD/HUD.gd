extends Control

onready var fuel_bar = $Footer/Fuel/FuelBar
onready var dV_labe = $Footer/Fuel/VD
onready var live_bar = $Footer/Life/Bar
onready var credit_labe = $Credits/Value
onready var tmr_labe = $DataBox/TMR/Value
onready var g_labe = $DataBox/G_Meter/Value
onready var mass_labe = $DataBox/MASS/Value
onready var refuel = $Refuel

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
	if(!is_instance_valid(ship)):return
	live_bar.value = int(ship.hitpoints as float/ship.max_hitpoints as float *100)
	
	if Input.is_action_just_pressed("info"):
		if(!ship.docking_location!=null):
			if(!$DeliveryMissionOverview.visible):
				$DeliveryMissionOverview.show()
			else:
				$DeliveryMissionOverview.hide()	
	pass
	
	tmr_labe.text = str("%0.1f" % Engine.get_frames_per_second())

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
	var missionCartMass = $DeliveryBoard.missionCartMass
	
	var dV = fuel / (ship.mass+missionCartMass)
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
		if(ship.autoCircle):
			v_labe.text = "A"+ v_labe.text  
		
		v_cosmic.text = str("%0.1f" % kosmic) 
	
		v_escape.text = str("%0.1f" % escape)


func _on_Ship_docked(port:Port):
	$DeliveryBoard.setPort(port)
	$CenterHUB.hide()
	$DataBox.hide()
	$DeliveryMissionOverview.show()
	refuel.show()
	refuel.setShip(ship)
	if(!port.getShipsForSale().empty()):
		$ShipShopButton.show()
		$ShipShop.setWarft(port)
	else:
		$ShipShopButton.hide()
		

func _on_Ship_undocked(port:Port):
	$DeliveryBoard.clearPort(port)
	$CenterHUB.show()
	$DataBox.show()
	$DeliveryMissionOverview.hide()
	$ShipShopButton.hide()
	$ShipShop.hide()
	refuel.hide()
	inShipShop = false

func _on_InventoryWindow_accepted(container):
	Player.accept_Mission(container)
	$DeliveryMissionOverview.update()
	
func _on_CargoBay_deliver(container):
	Player.deliver_Mission(container)
	$DeliveryMissionOverview.update()

func _on_CargoBay_about(container):
	Player.about_Mission(container)
	$DeliveryMissionOverview.update()
	#$DeliveryBoard.update()


func _on_Button_pressed():
	if(!inShipShop):
		$DeliveryMissionOverview.hide()
		$DeliveryBoard.hide()
		$ShipShop.show()
		self.inShipShop=true
	else:
		$DeliveryMissionOverview.show()
		$DeliveryBoard.show()
		$ShipShop.hide()
		self.inShipShop=false


func _on_shipOrderd(ship):
	self.emit_signal("shipOrderd",ship)
	if($ShipShop.warft.getShipsForSale().empty()):
		_on_Button_pressed()
		$ShipShopButton.hide()
