extends Control

@onready var fuel_bar = $Footer/Fuel/FuelBar
@onready var fuel_cart_bar = $Footer/Fuel/FuelCartBar
@onready var dV_labe = $Footer/Fuel/VD
@onready var live_bar = $Footer/Life/Bar

@onready var credit_labe = $Credits/Value

@onready var dataBox = $DataBox
@onready var tmr_labe = $DataBox/TMR/Value
@onready var g_labe = $DataBox/G_Meter/Value
@onready var mass_labe = $DataBox/MASS/Value


@onready var hud = $CenterHUB
@onready var v_labe = $CenterHUB/V_Meter/Value
@onready var v_cosmic = $CenterHUB/V_cosmic/Value
@onready var v_escape = $CenterHUB/V_escape/Value

@onready var missionBoard = $MissionBoard
@onready var refuel = $Refuel
@onready var accept_button = $Button

@onready var shipShop_button = $ShipShopButton
@onready var shipShop = $ShipShop

@onready var shipInvertoryView = $ShipInventoryView



signal shipOrderd(ship)

var inShipShop=false

var ship_mass = 0
var strongest_body:simpelPlanet = null
var ship_position:Vector3
var ship:Ship
# Called when the node enters the scene tree for the first time.
func _ready():	
	Player.credits_changed.connect(_on_credits_changed)
	shipShop_button.hide()
	credit_labe.text = str(Player.credits)	
	pass

func _process(delta):
	if(!is_instance_valid(ship)):return
	live_bar.value = int(ship.hitpoints as float/ship.max_hitpoints as float *100)
	
	if Input.is_action_just_pressed("info"):
		if(!ship.docking_location!=null):
			if(!shipInvertoryView.visible):
				shipInvertoryView.show()
			else:
				shipInvertoryView.hide()	
	pass
	
	tmr_labe.text = str("%0.1f" % Engine.get_frames_per_second())

func setShip(ship:Ship):
	self.ship = ship
	ship_mass = ship.mass
	ship.docked.connect(_on_Ship_docked)	
	ship.fuel_changed.connect(_on_Ship_fuel_changed)
	ship.g_force_update.connect(_on_Ship_g_force_update)
	ship.mass_changed.connect(_on_Ship_mass_changed)
	ship.telemetry_changed.connect(_on_Ship_telemetry_changed)
	ship.undocked.connect(_on_Ship_undocked)
	_on_Ship_fuel_changed(ship.fuel,ship.fuel_cap)

func _on_Ship_fuel_changed(fuel,fuel_cap):
	var missionCartMass = missionBoard.missionCartMass
		
	var dV = ship.get_delta_v(missionCartMass)	
	dV_labe.text = str("%0.1f" %  dV) + " dV"
	fuel_bar.value = int(fuel / fuel_cap *100)
	#fuel_bar.value = fuel / ship.mass

func _on_credits_changed(credits):
	credit_labe.text = str(credits)


func _on_Ship_mass_changed(mass):
	ship_mass = mass
	mass_labe.text = str(mass)
	tmr_labe.text = str("%0.2f" % (ship.get_thrust()/mass))
	missionBoard._on_ship_mass_change()


func _on_Ship_g_force_update(force,p_stronges_body,strongest_force):
	self.strongest_body = p_stronges_body as simpelPlanet
	g_labe.text = str("%0.2f" % (force.length()/ship_mass)) + " (" + str(strongest_body.name) + ")"	

func _on_Ship_telemetry_changed(position,velocety):
	self.ship_position = position
	if(strongest_body != null):
		var stronges_body_v = strongest_body.recorded_global_linear_velocity
		velocety -= stronges_body_v
		
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
	missionBoard.setPort(port)
	hud.hide()
	dataBox.hide()
	shipInvertoryView.show()
	refuel.show()
	refuel.setShip(ship)
	accept_button.show()
	if(!port.getShipsForSale().is_empty()):
		shipShop_button.show()
		shipShop.setWarft(port)
	else:
		shipShop_button.hide()
		

func _on_Ship_undocked(port:Port):
	missionBoard.clearPort(port)
	hud.show()
	dataBox.show()
	shipInvertoryView.hide()
	shipShop_button.hide()
	shipShop.hide()
	accept_button.hide()
	refuel.hide()
	inShipShop = false
	fuel_cart_bar.value = 0

func _on_InventoryWindow_accepted(container):
	Player.accept_Mission(container)
	shipInvertoryView.update()
	
func _on_CargoBay_deliver(container):
	Player.deliver_Mission(container)
	shipInvertoryView.update()

func _on_CargoBay_about(container):
	Player.about_Mission(container)
	shipInvertoryView.update()
	#$DeliveryBoard.update()


func _on_Button_pressed():
	if(!inShipShop):
		shipInvertoryView.hide()
		missionBoard.hide()
		shipShop.show()
		self.inShipShop=true
	else:
		shipInvertoryView.show()
		missionBoard.show()
		shipShop.hide()
		self.inShipShop=false


func _on_shipOrderd(ship):
	self.emit_signal("shipOrderd",ship)
	if(shipShop.warft.getShipsForSale().is_empty()):
		_on_Button_pressed()
		shipShop_button.hide()


func _on_refuel_cart_change(amount):
	if(amount ==0):
		fuel_cart_bar.value =0	
	else:
		fuel_cart_bar.value = (amount + ship.fuel)/ float(ship.fuel_cap) *100.0
	dV_labe.text = str("%0.2f" % ship.get_delta_v(0,amount * Globals.get_fuel_mass()))
