extends "res://Mission/Delivery/DeliveryMissionOverview.gd"

onready var mass_value = $Footer/mass_value
onready var max_mass_value = $Footer/max_mass_value

var missionCart = []
var missionCartSlots = 0
var missionCartMass = 0
var missionCartReward = 0

var port : Port
signal accepted(container)
signal cartUpdate(slots,mass,reward)

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
	missionCart = []
	missionCartSlots = 0
	missionCartMass = 0
	missionCartReward = 0
	self.hide()
	var existingConnection = target.inventory.is_connected("container_added", self, "_Inventory_added_container")
	if(existingConnection):
		target.inventory.disconnect("container_added", self, "_Inventory_added_container")

func update():
	.update()
	max_mass_value.text  = str("%0.2f" % ship.getMaxStartMass())
	mass_value.text = str("%0.2f" % (ship.mass+missionCartMass))

func _add_mission(mission:DeliveryMission):	
	var newRaw = rawScene.instance()	
	newRaw.setContent(mission)
	newRaw.connect("buttonPressed",self,"_on_selection_update")
	#newRaw.setButtonActon("Accept")
	if(missionCart.has(mission)):
		newRaw.checkBox()
	else:
		if(Player.ship.getFreeCargoSlots()<mission.getContainerCount()+missionCartSlots):
			newRaw.setButtonDisabeld()
	vBox.add_child(newRaw) # Add it as a child of this node.

func _on_selection_update(mission:DeliveryMission,state):
	if(state==true):
		missionCart.append(mission)
		missionCartSlots+=mission.getContainerCount()
		missionCartMass+=mission.getMass()
		missionCartReward+=mission.reward
	else:
		missionCart.erase(mission)
		missionCartSlots-=mission.getContainerCount()
		missionCartMass-=mission.getMass()
		missionCartReward-=mission.reward
	update()
	#self.emit_signal("cartUpdate",missionCartSlots,missionCartMass,missionCartReward)
	#print(missionCart)
	#print(missionCartSlots)
	#print(missionCartMass)
	#print(missionCartReward)

func _on_accepted():
	for mission in missionCart:
		emit_signal("accepted",mission)
	missionCart = []
	missionCartSlots = 0
	missionCartMass = 0
	missionCartReward = 0
	update()

func _on_visibility_changed():
	if(self.is_visible_in_tree()):
		update()
			
		
func setShip(ship:Ship):
	self.ship = ship
