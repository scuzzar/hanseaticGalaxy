extends "res://Mission/Delivery/DeliveryMissionOverview.gd"

onready var mass_value = $Footer/mass_value
onready var max_mass_value = $Footer/max_mass_value

#var destinationMap={}


var port : Port
signal accepted(container)

func _getMissions():
	return port.get_all_DeliveryMissions()

func setPort(target):
	self.port = target
	self.show()
	self.update()
	var existingConnection = target.inventory.is_connected("container_added", self, "_Inventory_added_container")
	if(!existingConnection):	
		target.inventory.connect("container_added", self, "_Inventory_added_container")

func clearPort(target):
	self.port = null
	self.hide()	
	var existingConnection = target.inventory.is_connected("container_added", self, "_Inventory_added_container")
	if(existingConnection):
		target.inventory.disconnect("container_added", self, "_Inventory_added_container")

func update():
	.update()
	max_mass_value.text  = str("%0.2f" % ship.getMaxStartMass())
	mass_value.text = str("%0.2f" % ship.mass)

func _add_mission(mission:DeliveryMission):	
	var newRaw = rawScene.instance()	
	newRaw.setContent(mission)
	newRaw.connect("buttonPressed",self,"_on_accepted")
	newRaw.setButtonActon("Accept")
	if(Player.ship.getCargoSlotCount()<mission.getContainerCount()):
		newRaw.setButtonDisabeld()
	vBox.add_child(newRaw) # Add it as a child of this node.

func _on_accepted(mission:DeliveryMission):
	emit_signal("accepted",mission)
	update()

func _on_visibility_changed():
	if(self.is_visible_in_tree()):
		update()
			
		
func setShip(ship:Ship):
	self.ship = ship
