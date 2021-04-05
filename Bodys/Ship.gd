extends Rigid_N_Body

class_name Ship

export var turn_rate = 3
export var trust = 100.0
export var dispay_name = "Neubeckum II"
export var fuel_cap = 5000.0
var fuel = fuel_cap
export var credits = 0

var docking_location: Node

func _ready():
	._ready()	
	emit_signal("fuel_changed",fuel)
	emit_signal("credits_changed",credits)
	print("ship:",trust/mass)
	
signal fuel_changed(fuel)
signal credits_changed(credits)

func _integrate_forces(state:PhysicsDirectBodyState):
	._integrate_forces(state)
	$Model.trust_forward_off()
	if Input.is_action_pressed("burn_forward"):
		var fuelcost =  trust * state.step
		if(fuel - fuelcost > 0):
			$Model.trust_forward_on()
			_burn_forward(state)
	
	_rotation(state,0)
	if Input.is_action_pressed("trun_left"):
		_rotation(state,turn_rate)	
	
	if Input.is_action_pressed("turn_right"):
		_rotation(state,turn_rate*-1)
	
	if Input.is_action_pressed("cheat_fuel"):
		self.set_fuel(fuel_cap)
	
func _rotation(state :PhysicsDirectBodyState, angle: float):
	state.set_angular_velocity(Vector3(0,angle,0))

func _get_forward_vector():
	var orientation = self.rotation.y
	var v = Vector3(0,0,-1)
	v = v.rotated(Vector3(0,1,0), orientation)
	return v

func burn_fuel(fuel_cost:float):
	self.set_fuel(fuel - fuel_cost)	
	
func set_fuel(pFuel:float):
	fuel = pFuel
	emit_signal("fuel_changed",fuel)

func _burn_forward(state:PhysicsDirectBodyState):	
	var force = _get_forward_vector()*trust
	state.add_force(force, Vector3(0,0,0))
	self.burn_fuel(trust * state.step)
	
func reward(reward_credits : int):
	credits += reward_credits
	print(credits)
	emit_signal("credits_changed",credits)

func load_containter(c : MissionContainer) -> bool:
	var added = $Inventory.addContainerOnFree(c)	
	return added

func unload_containter(c : MissionContainer):	
	$Inventory.removeContainer(c)	

func can_load_container() -> bool:
	return $Inventory.hasSpace()

func dock(target: Node):
	self.docking_location = target

func undock():
	self.docking_location = null

func container_clicked(c: MissionContainer):	
	if(self.docking_location == c.destination):
		self.reward(c.reward)
		self.unload_containter(c)		
	else:
		print("container hit on Ship:" + c.destination.name)

