extends Control

var mission : DeliveryMission

signal buttonPressed(mission)


func setContent(m:DeliveryMission):
	self.mission = m
	$raw/HBoxContainer/Good.text = mission.getCargoName()
	$raw/HBoxContainer/Destination.text = mission.destination.name
	$raw/HBoxContainer/Mass.text = str(mission.getMass())
	$raw/HBoxContainer/Reward.text = str(mission.reward)

func _on_Buy_pressed():
	emit_signal("buttonPressed",mission)	

func setAbout():
	$raw/HBoxContainer/Buy.text = "About"	
