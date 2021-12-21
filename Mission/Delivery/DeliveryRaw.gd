extends Control

var mission : DeliveryMission

signal buttonPressed(mission)

func setButtonActon(action:String):
	$raw/HBoxContainer/Buy.text = action

func setContent(m:DeliveryMission):
	self.mission = m
	$raw/HBoxContainer/Good.text = mission.getCargoName()
	$raw/HBoxContainer/Destination.text = mission.destination.name
	
	if(mission.getContainerCount()==1):
		$raw/HBoxContainer/Mass.text = str(mission.getMass())
	else:
		$raw/HBoxContainer/Mass.text = str(mission.getMass()/mission.getContainerCount()) + " x " + str(mission.getContainerCount())
	
	$raw/HBoxContainer/Reward.text = str(mission.reward)

func _on_Buy_pressed():
	emit_signal("buttonPressed",mission)	

