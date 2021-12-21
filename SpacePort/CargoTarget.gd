
extends Node
class_name CargoTarget
export(CargoContainer.CARGO) var cargo = CargoContainer.CARGO.NONE

var initial_name

#onready var port:Port = self.get_parent()
#var cargoName = MissionContainer.new().names[cargo]
const groupTag = "TARGET"

func _enter_tree():
	if(cargo!=CargoContainer.CARGO.NONE):
		self.add_to_group(groupTag+str(cargo))
	initial_name=self.name

func get_Port()->Port:
	if(self.get_parent() is Port):
		return self.get_parent() as Port
	else:
		return self.get_parent().get_parent()  as Port
