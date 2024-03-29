extends Control

var mission : DeliveryMission

signal buttonPressed(mission,state)

func setButtonActon(action:String):
	$raw/HBoxContainer/Buy.text = action

func setButtonDisabeld():
	$raw/HBoxContainer/Buy.disabled = true

func checkBox():
	$raw/HBoxContainer/Buy.pressed = true

func setContent(m:DeliveryMission):
	self.mission = m
	$raw/HBoxContainer/Good.text = mission.getCargoName()
	$raw/HBoxContainer/Destination.text = mission.destination.name	
	if((mission.destination as Port).getBody().securety_level==ENUMS.SECURETY.BELT):
		$raw/HBoxContainer/Destination.text += "*"
		
	if(mission.getContainerCount()==1):
		$raw/HBoxContainer/Mass.text = str(mission.getMass())
	else:
		$raw/HBoxContainer/Mass.text = str(mission.getContainerCount())  + " x " + str(mission.getMass()/mission.getContainerCount()) 
	
	$raw/HBoxContainer/Reward.text = str(mission.reward)
	
	$raw/HBoxContainer/H_dv.text = str("%0.1f" %D_V_Estimator.mission_d_v(mission))
	
	
	
	
func _on_Buy_pressed():
	emit_signal("buttonPressed",mission,$raw/HBoxContainer/Buy.pressed)	

