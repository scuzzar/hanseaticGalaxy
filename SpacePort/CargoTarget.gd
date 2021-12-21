extends Node
class_name CargoTarget
export(CargoContainer.CARGO) var cargo
onready var port:Port = self.get_parent()
#var cargoName = MissionContainer.new().names[cargo]
const groupTag = "TARGET"

func _enter_tree():
	self.add_to_group(groupTag+str(cargo))	
func _ready():
	
	pass

func get_Port()->Port:
	return self.get_parent() as Port
