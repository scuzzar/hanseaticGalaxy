extends Panel

var rawScene = preload("res://Mission/Delivery/DeliveryRaw.tscn")
onready var vBox = $"Container/VBoxContainer"

onready var mass_value = $Footer/mass_value
onready var max_mass_value = $Footer/max_mass_value

#var destinationMap={}

var ship:Ship

var port : Port
signal accepted(container)

func _ready():	
	hide()	
	pass 

func update():
	if(self.visible):
		for n in vBox.get_children():
			vBox.remove_child(n)
			n.queue_free()
		var container = port.get_all_DeliveryMissions()
		container.sort_custom(self,"_sortByDistance")
		for c in container:
			_add_container(c)
	mass_value.text = str(ship.mass)
	

func _sortByDistance(a,b):	
	return a.getDistance() < b.getDistance()

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

func _Inventory_added_container(container:DeliveryMission):
	update()

func _add_container(container:DeliveryMission):	
	var newRaw = rawScene.instance()	
	newRaw.setContent(container)
	newRaw.connect("buttonPressed",self,"_on_accepted")
	vBox.add_child(newRaw) # Add it as a child of this node.

func _on_accepted(container:DeliveryMission):
	emit_signal("accepted",container)
	update()

func _on_visibility_changed():
	if(self.is_visible_in_tree()):
		update()
		max_mass_value.text  = str("%0.2f" % ship.getMaxStartMass())	
		
func setShip(ship:Ship):
	self.ship = ship
