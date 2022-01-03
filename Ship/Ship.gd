extends Rigid_N_Body

class_name Ship

var price = 0

var turn_rate = 100

var trust = 100.0
var lateral_trust = 20.0

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
export var physikAktiv =true
var soiPlanet=null
var mounts = []
var dryMass = 5 
var turn_to_target = false
var target:Ship = null
var weaponActive = true

onready var inventory = $Inventory

export(ENUMS.TEAM) var team = ENUMS.TEAM.NEUTRAL
export(SHIPTYPES) var type = SHIPTYPES.NONE

const ShipTyp = preload("res://Ship/shipTypes.csv").records

signal fuel_changed(fuel, fuel_cap)
signal mass_changed(mass,trust)
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
	emit_signal("mass_changed",mass,trust)
	#$Model.all_trust_off()
	self.angular_damp = 6
	$ShipInfo.ship = self
	$ShipInfo.update()
	$ShipInfo.hide()
	var children = self.get_children()
	for c in children:
		if(c is mount_point):
			mounts.append(c)

func _loadType():
	dryMass = ShipTyp[type]["dry_mass"]
	turn_rate = ShipTyp[type]["turn_rate"]
	trust = ShipTyp[type]["trust"]
	lateral_trust = ShipTyp[type]["lateral_trust"]
	dispay_name = ShipTyp[type]["display_name"]
	fuel_cap = ShipTyp[type]["fuel_cap"]
	price = ShipTyp[type]["price"]
	max_hitpoints = ShipTyp[type]["max_hp"]

func _integrate_forces(state:PhysicsDirectBodyState):
	if(physikAktiv):
		._integrate_forces(state)
	
	var currentSOIPlanet = self.getSOIPlanet()
	if( currentSOIPlanet != soiPlanet):
		soiPlanet=currentSOIPlanet
		emit_signal("soiPlanetChanged",soiPlanet)
	
	var trusted = false

	if(playerControl):
		
		if(weaponActive):
			_turn_turrents(state.step)
			if Input.is_action_pressed("fire"):	
				self.fire()		
		
		if Input.is_action_pressed("burn_forward"):
			if(self.docking_location!=null):
				self.undock()
			var fuelcost =  trust * state.step
			if(fuel - fuelcost > 0):
				$Model.trust_forward_on()
				trusted = true
				_burn_forward(state)
		
		
		if Input.is_action_pressed("burn_backward"):
			$Model.trust_backward_on()
			trusted = true
			_burn_backward(state)
			
		if Input.is_action_pressed("burn_lateral_left"):
			$Model.trust_lateral_left_on()
			trusted = true
			_burn_left(state)
			
		if Input.is_action_pressed("burn_lateral_right"):
			$Model.trust_lateral_right_on()
			trusted = true
			_burn_right(state)
		
		if Input.is_action_pressed("burn_circularize"):	
			_burn_circularize(state)
		
		if Input.is_action_pressed("trun_left"):
			_rotation(turn_rate*state.step)	
		
		if Input.is_action_pressed("turn_right"):
			_rotation(turn_rate*-1*state.step)
			
		if Input.is_action_just_pressed("info"):
			if(!$ShipInfo.visible):
				$ShipInfo.setShip(self)				
				$ShipInfo.show()
				$ShipInfo.update()
			else:
				$ShipInfo.hide()	
		emit_signal("telemetry_changed", self.translation, state.linear_velocity)
		
		if(!trusted):
			$Model.all_trust_off()

func _turn_turrents(delta):
	var position2D = get_viewport().get_mouse_position()
	var dropPlane  = Plane(Vector3(0, 1, 0), 0)
	var camera = get_viewport().get_camera()
	var position3D = dropPlane.intersects_ray(
							 camera.project_ray_origin(position2D),
							 camera.project_ray_normal(position2D))
	if(position3D!=null):
		for mount in mounts :
			var ownTransform:Transform = mount.global_transform
			var look_transform = ownTransform.looking_at(position3D,Vector3(0,1,0))
			var angle = look_transform.basis.get_euler().y
			
			var nt:Transform = mount.no_turn_transform
			var st:Transform = self.global_transform
			
			nt = nt.rotated(Vector3(0,1,0),st.basis.get_euler().y-PI/2)
			
			var n = nt.basis.get_euler().y
			var l = mount.turn_limit
			var n_max = nt.rotated(Vector3(0,1,0),l).basis.get_euler().y
			var n_min = nt.rotated(Vector3(0,1,0),l*-1).basis.get_euler().y
			
			var d = (look_transform.rotated(Vector3(0,1,0),nt.basis.get_euler().y*-1)).basis.get_euler().y
			#var d = (look_transform.rotated(Vector3(0,1,0),st.basis.get_euler().y*-1+PI)).basis.get_euler().y
			if(d>=l): angle = n_max
			if(d<=l*-1): angle = n_min
			
			var angleD = angle - ownTransform.basis.get_euler().y
			
			var turnrate =mount.turn_rate
			var turnAngle =angleD#  clamp(angleD,mount.turn_rate*-1*delta,mount.turn_rate*delta)
	
			(mount as Spatial).global_rotate(Vector3(0,1,0),turnAngle)
	

func _burn_forward(state:PhysicsDirectBodyState):	
	var force = _get_forward_vector()*trust
	state.add_force(force, Vector3(0,0,0))
	self.burn_fuel(trust * state.step)

func _burn_right(state:PhysicsDirectBodyState):	
	var force = _get_right_vector()*lateral_trust
	state.add_force(force, Vector3(0,0,0))
	self.burn_fuel(lateral_trust * state.step)

func _burn_left(state:PhysicsDirectBodyState):	
	var force = _get_left_vector()*lateral_trust
	state.add_force(force, Vector3(0,0,0))
	self.burn_fuel(lateral_trust * state.step)

func _burn_backward(state:PhysicsDirectBodyState):	
	var force = _get_forward_vector()*lateral_trust*-1
	state.add_force(force, Vector3(0,0,0))
	self.burn_fuel(lateral_trust * state.step)

func _burn_circularize(state:PhysicsDirectBodyState):
	var ov = self._get_orbital_vector()
	var c_burn_direction = ov - state.linear_velocity
	#var c_burn_direction_retro = ov.rotated(Vector3(0,1,0),PI)- state.linear_velocity
	#if(c_burn_direction.length()>c_burn_direction_retro.length()):
	#	c_burn_direction = c_burn_direction_retro
	
	var c_burn_dv = c_burn_direction.length()
	
	var c_burn_trust = clamp(lateral_trust,0,c_burn_dv/state.step)
	#c_burn_trust = clamp(c_burn_trust,0,c_burn_dv)
	#print(c_burn_trust)
	var c_burn_f = c_burn_direction.normalized() * c_burn_trust
	state.add_force(c_burn_f, Vector3(0,0,0))
	
	self.burn_fuel(c_burn_trust * state.step)


func _get_orbital_vector():
	var b :simpelPlanet = last_g_force_strongest_Body
	#print(b.name)
	var b_direction : Vector3 =self.global_transform.origin - b.global_transform.origin
	
	var orbital_direction = b_direction.normalized().rotated(Vector3(0,1,0),PI/2)
	
	var d =	b_direction.length()
	var M = b.mass
	var kosmic = sqrt(Globals.G*M/d)
	
	var orbital_vector_in_Sio =(orbital_direction * kosmic)
	
	#account for motion of b
	var result =orbital_vector_in_Sio+b.linear_velocity
	return result

func _rotation( angle: float):
	self.apply_torque_impulse(Vector3(0,angle,0))

func _get_forward_vector():
	var orientation = self.rotation.y
	var v = Vector3(0,0,1)
	v = v.rotated(Vector3(0,1,0), orientation)
	return v

func _get_right_vector():
	var orientation = self.rotation.y
	var v = Vector3(-1,0,0)
	v = v.rotated(Vector3(0,1,0), orientation)
	return v
	
func _get_left_vector():
	var orientation = self.rotation.y
	var v = Vector3(1,0,0)
	v = v.rotated(Vector3(0,1,0), orientation)
	return v

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
	Player.fuel_burned(fuel_cost)
	
func set_fuel(pFuel:float):
	fuel = pFuel
	emit_signal("fuel_changed",fuel, fuel_cap)

func get_refule_costs():
	var fuelprice = 1000
	var fuel_to_By = self.fuel_cap - fuel
	var credits_to_pay = fuel_to_By*fuelprice/1000
	return credits_to_pay

func load_containter(c : CargoContainer) -> bool:
	var added = $Inventory.addContainerOnFree(c)
	self.mass += c.getMass()	
	emit_signal("mass_changed",mass,trust)
	return added

func load_all_container(ContainerArray):
	for c in ContainerArray:
		self.load_containter(c)

func unload_all_container(ContainerArray):
	for c in ContainerArray:
		self.unload_containter(c)

func unload_containter(c : CargoContainer):
	self.mass -= c.getMass()	
	$Inventory.removeContainer(c)	
	emit_signal("mass_changed",mass,trust)

func getListOfContainer():
	return $Inventory.getAllContainter()

func can_load_container(count:int) -> bool:
	return $Inventory.freeSpace()>=count


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
		"trust" : trust,
		"price" : price,
		"type" : type,
		"mass" : mass,
		"hitpoints" :hitpoints
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
	trust = dict["trust"]
	price = dict["price"]
	type = dict["type"]
	hitpoints = dict["hitpoints"]
	last_g_force = Vector3(0,0,0)

func takeDamege(damage):
	self.hitpoints -= damage	
	emit_signal("tookDamage",damage)
	if(hitpoints<=0):
		self.distroy()
		
func distroy():
	if(playerControl):
		self.hide()
	else:
		self.queue_free()
	emit_signal("destryed")


func hasTarget():
	return target!=null

func fire():
	var fired = false
	for mount in mounts :
		fired = fired or mount.fire()
	return fired
