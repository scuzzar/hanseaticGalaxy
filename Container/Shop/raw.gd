extends Control

onready var good_lable = $raw/HBoxContainer/Good
onready var destination_lable = $raw/HBoxContainer/Destination
onready var distance_lable = $raw/HBoxContainer/Distance
onready var reward_lable = $raw/HBoxContainer/Reward

var container

signal accepted(container)

func setContent(container:MissionContainer):
	self.container = container
	$raw/HBoxContainer/Good.text = container.getCargoName()
	$raw/HBoxContainer/Destination.text = container.destination.name
	$raw/HBoxContainer/Mass.text = str(container.getMass())
	$raw/HBoxContainer/Reward.text = str(container.reward)

func _on_Buy_pressed():
	emit_signal("accepted",container)	
