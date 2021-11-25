extends Control

var container

signal buttonPressed(container)


func setContent(container:MissionContainer):
	self.container = container
	$raw/HBoxContainer/Good.text = container.getCargoName()
	$raw/HBoxContainer/Destination.text = container.destination.name
	$raw/HBoxContainer/Mass.text = str(container.getMass())
	$raw/HBoxContainer/Reward.text = str(container.reward)

func _on_Buy_pressed():
	emit_signal("buttonPressed",container)	

func disable():
	$raw/HBoxContainer/Buy.disabled = true
