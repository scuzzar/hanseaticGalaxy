extends Node

var SOIPlanet: simpelPlanet=null
var angular_speed_shift= 0;
var velocity_shift =Vector3(0,0,0)

export var activ = true
export var logging = false

func _ready():
	pass # Replace with function body.

func on_soi_planet_changed(newPlanet:simpelPlanet):
	print(newPlanet)
	if(newPlanet==null):
		_unShift()
	else:
		_shiftToPlanet(newPlanet)		


func _shiftToPlanet(newPlanet):	
		SOIPlanet = newPlanet
		_shift(-newPlanet.angular_speed, SOIPlanet.linear_velocity*-1)		
		

func _unShift():
		_shift(angular_speed_shift*-1,velocity_shift*-1 )
		SOIPlanet = null

func _shift(angilar_shift, vel_shift):
	#Shift SOI Planet
	SOIPlanet.angular_speed += angilar_shift
	angular_speed_shift += angilar_shift
	
	#shift ship Speed
	velocity_shift = vel_shift 
	if(velocity_shift.length()<100):
		if(logging):
			print("Old Ship Vel"+ str($"../PlayerShip".linear_velocity))
			$"../PlayerShip".linear_velocity += velocity_shift
			print("new Ship Vel"+ str($"../PlayerShip".linear_velocity))
	
	if(logging):
		print("Roational Shift"+ str(angular_speed_shift))
		print("Velocity Shift"+ str(velocity_shift))
		
