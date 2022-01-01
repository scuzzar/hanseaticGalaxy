extends Node

onready var KillSatScene = preload("res://Enemys/KillSatEnemy.tscn")

func _ready():
	print("Pirates ready")

func on_mission_generated(mission):
	#print("Pirates heared of mission" + str(mission))
	pass

func on_mission_accepted(mission):
	if(mission is DeliveryMission):
		var dm = mission as DeliveryMission
		print("Pirates heared of accepted mission: " + str(dm))
		_generate_pirate(dm.destination)

func _generate_pirate(place:Port):
	if(place is SpaceStation):
		_generate_pirates_Station(place as SpaceStation)
	else:
		_generate_pirates_Ground(place as Port)
	pass

func _generate_pirates_Station(station:SpaceStation):
	var satellite = station.get_parent() as Satellite
	var planet = satellite.get_parent() as simpelPlanet	
	if planet.securety_level != ENUMS.SECURETY.BELT : return
	var killSat : Satellite = KillSatScene.instance()	
	killSat.transform.origin = Vector3(satellite.orbit_radius,0,0)	
	planet.add_child(killSat)	
	killSat.orbit_radius = satellite.orbit_radius
	killSat.angle = satellite.angle + 0.2
	pass	
	
func _generate_pirates_Ground(groundPort:Port):	
	var planet = groundPort.get_parent() as simpelPlanet
	if planet.securety_level != ENUMS.SECURETY.BELT : return
	var killSat : Satellite = KillSatScene.instance()
	killSat.transform.origin = Vector3(planet.radius*1.3,0,0)
	planet.add_child(killSat)
	pass	
