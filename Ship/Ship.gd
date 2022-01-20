extends Rigid_N_Body

class_name Ship

var price = 0

var turn_rate = 100

var engine_exaust_velocity :float = 200
var engine_mass_rate :float = 1

var truster_exaust_velocity :float = 10
var truster_engine_mass_rate :float = 0.1

enum SHIPTYPES{
	TENDER = 0,
	TENDER_S = 1,
	ROCKET_S = 2,
	ROCKET = 3,
	SKYCRANE = 4,
	SKYCRANE_S = 5,
	KILLSAT = 6,
	NONE = 999
}

var dispay_name = "Neubeckum II"
var fuel_cap = 5000.0
var fuel = 0
var docking_location: Node
var hitpoints = 100
var max_hitpoints = 100
export var playerControl = false

export var physicActiv =true setget setPhysics



export var autoCircle=false
var soiPlanet=null
var mounts = []
var dryMass = 5 
var cargoMass = 0
var fuelMass = 0
var turn_to_target = false
var target:Ship = null
var weaponActive = true

var truster_vector = Vector2(0,0)
var truster_trust :float = 0 
var rotational_trust :float = 0  


onready var inventory = $Inventory

export(ENUMS.TEAM) var team = ENUMS.TEAM.NEUTRAL
export(SHIPTYPES) var type = SHIPTYPES.NONE

const ShipTyp = preload("res://Ship/shipTypes.csv").records

signal fuel_changed(fuel, fuel_cap)
signal mass_changed(mass)
signal telemetry_changed(position,velocety)
signal soiPlanetChanged(newSOIPlanet)
signal docked(port)
signal undocked(port)
signal tookDamage(damage)
signal destryed()

func _ready():
	._ready()
	self._loadType()
	self.mass = dryMass
	self.hitpoints = max_hitpoints
	#fuel = fuel_cap
	emit_signal("fuel_changed",fuel, fuel_cap)	
	emit_signal("mass_changed",mass)
	#$Model.all_trust_off()
	self.angular_damp = 6
	$ShipInfo.ship = self
	$ShipInfo.update()
	$ShipInfo.hide()
	var children = self.get_children()
	for c in children:
		if(c is mount_point):
			mounts.append(c)
	calcWetMass()

func _loadType():
	dryMass = ShipTyp[type]["dry_mass"]
	turn_rate = ShipTyp[type]["turn_rate"]	
	dispay_name = ShipTyp[type]["display_name"]
	fuel_cap = ShipTyp[type]["fuel_cap"]
	price = ShipTyp[type]["price"]
	max_hitpoints = ShipTyp[type]["max_hp"]
	
	engine_exaust_velocity = ShipTyp[type]["engine_exaust_velocity"]
	engine_mass_rate = ShipTyp[type]["engine_mass_rate"]
	
	truster_exaust_velocity = ShipTyp[type]["truster_exaust_velocity"]
	truster_engine_mass_rate = ShipTyp[type]["truster_engine_mass_rate"]

func setPhysics(activ):
	physicActiv = activ
	if(activ):
		mode = RigidBody.MODE_RIGID
	else:
		mode = RigidBody.MODE_STATIC

func _integrate_forces(state:PhysicsDirectBodyState):
	if(physicActiv):
		._integrate_forces(state)
		self.calcWetMass()
		
	$Damage.handle_collsions(state)
	
	var currentSOIPlanet = self.getSOIPlanet()
	if( currentSOIPlanet != soiPlanet):
		soiPlanet=currentSOIPlanet
		emit_signal("soiPlanetChanged",soiPlanet)
	
	var trusted = false
	
	if autoCircle:
		$AutoPilot._lateral_circularize_burn(state)
	
	if(playerControl):		
		if(weaponActive):
			$TragetComputer._turn_turrents(state.step)
			if Input.is_action_pressed("fire"):	
				self.fire()		
		
		if Input.is_action_just_pressed("auto_orbit"):
			autoCircle = !autoCircle
		
		if Input.is_action_pressed("burn_forward"):
			if(self.docking_location!=null):
				self.undock()
			var fuelcost =  engine_mass_rate / Globals.get_fuel_mass()  * state.step
			if(fuel - fuelcost > 0):				
				trusted = true
				_fire_main_drive(state)
		else:
			$Propulsion.drive_off()
	
		###Truster fire		
		if Input.is_action_pressed("burn_backward"):
			lateral_burn(Vector2(-1,0))
			
		if Input.is_action_pressed("burn_lateral_left"):
			lateral_burn(Vector2(0,-1))
		
		if Input.is_action_pressed("burn_lateral_right"):
			lateral_burn(Vector2(0,1))	
				
		_fire_truster(state,truster_vector)	
		truster_vector = Vector2(0,0)	
		truster_trust = 0
		
		if Input.is_action_pressed("trun_left"):
			rotational_trust = turn_rate
		
		if Input.is_action_pressed("turn_right"):
			rotational_trust = turn_rate*-1
		
		_rotation(rotational_trust,state)	
		rotational_trust = 0		
		
		if Input.is_action_just_pressed("info"):
			if(!$ShipInfo.visible):
				$ShipInfo.setShip(self)				
				$ShipInfo.show()
				$ShipInfo.update()
			else:
				$ShipInfo.hide()	
		emit_signal("telemetry_changed", self.translation, state.linear_velocity)

func calcWetMass():
	self.mass = dryMass + cargoMass + fuel*Globals.get_fuel_mass()

func lateral_burn(burn_vector):
	truster_vector += burn_vector
	#truster_trust += lateral_trust

func _fire_truster(state:PhysicsDirectBodyState,direction:Vector2):
	if(direction.length()==0): return
	
	var direction3d = Vector3(direction.x,0,direction.y)	
	var orientation = self.rotation.y
	direction3d = direction3d.rotated(Vector3(0,1,0), orientation-PI/2)
	
	var fuel_cost = truster_engine_mass_rate / Globals.get_fuel_mass()  * state.step
	if(fuel_cost>fuel):return
	
	var force = direction3d*truster_engine_mass_rate*truster_exaust_velocity
	state.add_force(force, Vector3(0,0,0))
	self.burn_fuel(fuel_cost)
	$Propulsion.trust_Vector(direction,1)
	

func _fire_main_drive(state:PhysicsDirectBodyState):	
	var force = _get_forward_vector()*engine_mass_rate*engine_exaust_velocity
	state.add_force(force, Vector3(0,0,0))
	self.burn_fuel(engine_mass_rate / Globals.get_fuel_mass() * state.step)
	$Propulsion.drive_on()

func _get_forward_vector():
	var orientation = self.rotation.y
	var v = Vector3(0,0,1)
	v = v.rotated(Vector3(0,1,0), orientation)
	return v

func _rotation(angle: float, state):
	state.apply_torque_impulse(Vector3(0,angle*state.step,0))

func getSOIPlanet():
	if(last_g_force_strongest_Body==null):
		return null
	if(last_g_force_strongest_Body.isStar):
		return null
	if(last_g_force_strongest_Body.isPlanet):
		return last_g_force_strongest_Body
	else:
		return last_g_force_strongest_Body.get_parent()	

func rel_speed_to_Strongest_body():
	var SB = last_g_force_strongest_Body
	var result = 0
	print(SB.name)
	if(SB!=null):
		result = SB.linear_velocity.distance_to(self.linear_velocity)
	return result


func burn_fuel(fuel_cost:float):
	self.set_fuel(fuel - fuel_cost)		
	
func set_fuel(pFuel:float):
	fuel = pFuel
	fuelMass = fuel * Globals.get_fuel_mass()
	emit_signal("fuel_changed",fuel, fuel_cap)
	emit_signal("mass_changed",mass)

func get_refule_costs():
	var fuelprice = 1000
	var fuel_to_By = self.fuel_cap - fuel
	var credits_to_pay = fuel_to_By*fuelprice/1000
	return credits_to_pay

func load_containter(c : CargoContainer) -> bool:
	var added = $Inventory.addContainerOnFree(c)
	self.cargoMass += c.getMass()	
	emit_signal("mass_changed",mass)
	return added

func load_all_container(ContainerArray):
	for c in ContainerArray:
		self.load_containter(c)

func unload_all_container(ContainerArray):
	for c in ContainerArray:
		self.unload_containter(c)

func unload_containter(c : CargoContainer):
	self.cargoMass -= c.getMass()	
	$Inventory.removeContainer(c)	
	emit_signal("mass_changed",mass)

func getListOfContainer():
	return $Inventory.getAllContainter()

func can_load_container(count:int) -> bool:
	return $Inventory.freeSpace()>=count

func get_delta_v(additional_mass:float=0, additional_fuel_mass:float=0):
	var m0 : float = dryMass + fuelMass + additional_fuel_mass
	var mf : float = dryMass
	var dV : float = engine_exaust_velocity * log(m0/mf)
	return dV	

func get_thrust():
	return engine_exaust_velocity * engine_mass_rate

func get_lateral_trust():
	return truster_engine_mass_rate*truster_exaust_velocity

func dock(target: Node):
	if(target!=self.docking_location):
		self.docking_location = target
		self.weaponActive =false
		emit_signal("docked", self.docking_location)

func undock():
	if(self.docking_location!=null):
		emit_signal("undocked",  self.docking_location)
		self.docking_location = null
		self.weaponActive=true

func getCargoSlotCount():
	return $Inventory.slots.size()

func getFreeCargoSlots():
	return $Inventory.freeSpace()

func getMaxStartMass():
	if(last_g_force.length()>0):
		var result = engine_exaust_velocity*engine_mass_rate /last_g_force.length()*mass
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
		"price" : price,
		"type" : type,
		"mass" : mass#,
		#"hitpoints" :hitpoints
	}
	return save_dict

func load_save(dict):	
	transform.origin = Vector3(dict["pos_x"], dict["pos_y"],dict["pos_z"])	
	self.linear_velocity = Vector3(dict["velocety_x"], dict["velocety_y"],dict["velocety_z"])
	self.velocety = Vector3(dict["velocety_x"], dict["velocety_y"],dict["velocety_z"])	
	rotation.y = dict["rotation"]	
	self.set_fuel(dict["fuel"])
	fuel_cap = dict["fuel_cap"]
	mass = dryMass
	price = dict["price"]
	type = dict["type"]
	_loadType()
	#hitpoints = dict["hitpoints"]
	last_g_force = Vector3(0,0,0)
	self.contact_monitor = true
	self.contacts_reported = 5
	self.calcWetMass()

func takeDamege(damage):
	$Damage.takeDamege(damage)

func hasTarget():
	return target!=null

func fire():
	var fired = false
	for mount in mounts :
		fired = fired or mount.fire()
	return fired
