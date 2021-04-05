extends Node
class_name CargoTarget
export(MissionContainer.CARGO) var cargo
onready var port:Port = self.get_parent()
onready var cargoName = MissionContainer.new().names[cargo]
const groupTag = "_TARGET"

func _ready():
	self.add_to_group(cargoName+groupTag)	

func get_Port()->Port:
	return self.get_parent() as Port
