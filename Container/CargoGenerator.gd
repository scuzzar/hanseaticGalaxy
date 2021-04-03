extends Node

export(MissionContainer.CARGO) var cargo
export(float) var wait_time = 10
export(int) var max_store = 100

onready var port:Port = self.get_parent()
var MissionContainerScene = preload("res://Container/Container.scn")

func _ready():
	$GenTimer.wait_time = self.wait_time
	$GenTimer.start()

func _on_GenTimer_timeout():	
	if(port.has_Space() and port.stock(cargo)<max_store):
		var c = _generate_mission()
		port.add_container(c)
		


func _generate_mission() -> MissionContainer:
	var c = MissionContainerScene.instance()	
	c.destination = port.defaultMissionDestination
	c._set_cargo(cargo)
	c.reward = c.getPrice()
	return c
