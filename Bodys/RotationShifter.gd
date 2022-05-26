extends Node

var SOIPlanet: simpelPlanet=null
var angular_speed_shift= 0;
var velocity_shift =Vector3(0,0,0)

@export var activ = true
@export var logging = false

func _ready():
	pass # Replace with function body.

func _process(delta):	
	if Input.is_action_just_pressed("simulate"):
		self.toggel()

func toggel():
	if(activ):
		if(SOIPlanet!=null): _unShift()
		self.activ =false
		print("deactivated Rotational Shift")
	else:
		self.activ = true
		self.on_soi_planet_changed(SOIPlanet)
		print("activated Rotational Shift")

func on_soi_planet_changed(newPlanet:simpelPlanet):
	if(activ):
		if(newPlanet==null):
			if(SOIPlanet!=null):
				_unShift()
		else:
			if(newPlanet.doRotationShift):
				_shiftToPlanet(newPlanet)
	else:
		SOIPlanet = newPlanet

func _shiftToPlanet(newPlanet):	
		SOIPlanet = newPlanet
		_shift(-newPlanet.angular_speed, SOIPlanet.constant_linear_velocity*-1)		
		

func _unShift():
		_shift(angular_speed_shift*-1,velocity_shift*-1 )
		SOIPlanet = null

func _shift(angilar_shift, vel_shift):
	#Shift SOI Planet
	SOIPlanet.angular_speed += angilar_shift
	angular_speed_shift += angilar_shift
	
	#TODO:add planetary Rotation
	#SOIPlanet.planetaryRotation += angilar_shift
	
	#shift ship Speed
	velocity_shift = vel_shift 
	Globals.velocity_shift = vel_shift
	# dont shift ship if its first 
	if(velocity_shift.length()<1000):
		if(logging):print("Old Ship Vel"+ str($"../PlayerShip".linear_velocity))		
		$"../PlayerShip".write_linear_velocity($"../PlayerShip".linear_velocity + velocity_shift)
		if(logging):print("new Ship Vel"+ str($"../PlayerShip".linear_velocity))
	
	var bodys = get_tree().get_nodes_in_group("bodys")
	for b in bodys:
		var p = b as simpelPlanet
		if(p.isPlanet and SOIPlanet!=p):
			p.angular_speed += angilar_shift
	
	$"../Sun".planetaryRotation += angilar_shift
	
	if(logging):
		print("Roational Shift"+ str(angilar_shift))
		print("Velocity Shift"+ str(velocity_shift))
		
