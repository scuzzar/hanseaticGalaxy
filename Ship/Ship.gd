extends Rigid_N_Body

class_name Ship

export var price = 0
export var turn_rate = 100
export var trust = 100.0
export var dispay_name = "Neubeckum II"
export var fuel_cap = 5000.0
var fuel = fuel_cap
var docking_location: Node
export var playerControl = false
export var physikAktiv =true

onready var inventory = $Inventory

signal fuel_changed(fuel, fuel_cap)
signal mass_changed(mass,trust)
signal telemetry_changed(position,velocety)
signal docked(port)
signal undocked(port)

func _ready():	
	._ready()	
	emit_signal("fuel_changed",fuel, fuel_cap)	
	emit_signal("mass_changed",mass,trust)
	$Model.trust_forward_off()
	self.angular_damp = 6
	$ShipInfo.ship = self
	$ShipInfo.update()
	$ShipInfo.hide()

func _integrate_forces(state:PhysicsDirectBodyState):
	if(physikAktiv):
		._integrate_forces(state)
	
	$Model.trust_forward_off()	
	if(playerControl):
		if Input.is_action_pressed("burn_forward"):
			if(self.docking_location!=null):
				self.undock()
			var fuelcost =  trust * state.step
			if(fuel - fuelcost > 0):
				$Model.trust_forward_on()
				_burn_forward(state)

		if Input.is_action_pressed("trun_left"):
			_rotation(turn_rate*state.step)	
		
		if Input.is_action_pressed("turn_right"):
			_rotation(turn_rate*-1*state.step)
			
		if Input.is_action_just_pressed("info"):
			if(!$ShipInfo.visible):
				$ShipInfo.update()
				$ShipInfo.show()
			else:
				$ShipInfo.hide()
		
		emit_signal("telemetry_changed", self.translation, state.linear_velocity)

func _rotation( angle: float):
	self.apply_torque_impulse(Vector3(0,angle,0))

func _get_forward_vector():
	var orientation = self.rotation.y
	var v = Vector3(0,0,1)
	v = v.rotated(Vector3(0,1,0), orientation)
	return v

func burn_fuel(fuel_cost:float):
	self.set_fuel(fuel - fuel_cost)	
	Player.fuel_burned(fuel_cost)
	
func set_fuel(pFuel:float):
	fuel = pFuel
	emit_signal("fuel_changed",fuel, fuel_cap)

func _burn_forward(state:PhysicsDirectBodyState):	
	var force = _get_forward_vector()*trust
	state.add_force(force, Vector3(0,0,0))
	self.burn_fuel(trust * state.step)

func get_refule_costs():
	var fuelprice = MissionContainer.price[MissionContainer.CARGO.FUEL]
	var fuel_to_By = self.fuel_cap - fuel
	var credits_to_pay = fuel_to_By*fuelprice/1000
	return credits_to_pay

func load_containter(c : MissionContainer) -> bool:
	var added = $Inventory.addContainerOnFree(c)
	self.mass += c.getMass()	
	emit_signal("mass_changed",mass,trust)
	return added

func unload_containter(c : MissionContainer):
	self.mass -= c.getMass()	
	$Inventory.removeContainer(c)	
	emit_signal("mass_changed",mass,trust)

func getListOfContainer():
	return $Inventory.getAllContainter()

func can_load_container() -> bool:
	return $Inventory.hasSpace()

func dock(target: Node):
	if(target!=self.docking_location):
		self.docking_location = target
		emit_signal("docked", self.docking_location)

func undock():
	if(self.docking_location!=null):
		emit_signal("undocked",  self.docking_location)
		self.docking_location = null

func deliver_Container(c: MissionContainer):	
	if(self.docking_location == c.destination):
		Player.reward(c.reward)
		self.unload_containter(c)		
	else:
		print("container hit on Ship:" + c.destination.name)

func about_Container(c:MissionContainer):
	self.unload_containter(c)
	Player.pay(c.reward* 0.2)

func getCargoSlotCount():
	return $Inventory.slots.size()

func getMaxStartMass():
	if(last_g_force.length()>0):
		var result = trust/last_g_force.length()*mass
		return result
	else:
		return 0

func save():
	#Offset to avoid collisions on loading.
	var savePos = self.translation	
	var offset :Vector3 = self.last_g_force 
	offset = offset.normalized()*-0.4
	savePos = savePos + offset
	
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : savePos.x,
		"pos_y" : savePos.y,
		"pos_z" : savePos.z,
		"velocety_x" : velocety.x,
		"velocety_y" : velocety.y,
		"velocety_z" : velocety.z,
		"rotation" : rotation.y,
		"fuel": fuel,
		"fuel_cap" :fuel_cap,
		"mass" : mass
	}
	return save_dict

func load_save(dict):	
	transform.origin = Vector3(dict["pos_x"], dict["pos_y"],dict["pos_z"])	
	self.linear_velocity = Vector3(dict["velocety_x"], dict["velocety_y"],dict["velocety_z"])	
	rotation.y = dict["rotation"]	
	self.set_fuel(dict["fuel"])
	fuel_cap = dict["fuel_cap"]
	mass = dict["mass"]
	last_g_force = Vector3(0,0,0)
	#Send signal so HUD can update
	self.get_signal_connection_list("fuel_changed")
	pass


