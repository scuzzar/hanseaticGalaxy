extends Node

onready var KillSatScene = preload("res://Enemys/KillSatEnemy.tscn")
var RAN = RandomNumberGenerator.new()
func _ready():
	print("Pirates ready")

func on_mission_generated(mission):
	#print("Pirates heared of mission" + str(mission))
	pass

func on_mission_about(mission):
	pass

func on_mission_accepted(mission):
	if(mission is DeliveryMission):
		var dm = mission as DeliveryMission
		print("Pirates heared of accepted mission: " + str(dm))
		_generate_pirate(dm)

func _generate_pirate(mission:DeliveryMission):	
	var place = mission.destination	
	if(place is SpaceStation):
		_generate_pirates_Station(place as SpaceStation, mission)
	else:
		_generate_pirates_Ground(place as Port, mission)
	pass

func _generate_pirates_Station(station:SpaceStation, mission:DeliveryMission):
	var satellite = station.get_parent() as Satellite
	var planet = satellite.get_parent() as simpelPlanet	
	if planet.securety_level != ENUMS.SECURETY.BELT : return
	_place_pirate_in_orbit(planet,satellite.angle+0.3,satellite.orbit_radius, mission)
	_place_pirate_in_orbit(planet,satellite.angle-0.3,satellite.orbit_radius, mission)

	
func _generate_pirates_Ground(groundPort:Port, mission:DeliveryMission):	
	var planet = groundPort.get_parent() as simpelPlanet
	if planet.securety_level != ENUMS.SECURETY.BELT : return
	_place_pirate_in_orbit(planet,0,planet.radius*3,mission)
	_place_pirate_in_orbit(planet,2*PI/3,planet.radius*3,mission)
	_place_pirate_in_orbit(planet,2*PI/3*2,planet.radius*3,mission)
	pass

func _place_pirate_in_orbit(planet:simpelPlanet, angle, radius, mission:DeliveryMission):
	var killSat : Satellite = KillSatScene.instance()	
	killSat.transform.origin = Vector3(radius,0,0)	
	planet.add_child(killSat)	
	killSat.orbit_radius = radius
	killSat.angle = angle
	
	var b = mission.reward
	killSat.bounty = RAN.randf_range(b*0.10,b*0.75)
	mission.connect("aborted",killSat,"_on_mission_abouted")	
