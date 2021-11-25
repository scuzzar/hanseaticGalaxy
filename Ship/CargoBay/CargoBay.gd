extends Panel

var rawScene = preload("res://Ship/CargoBay/BayRaw.tscn")
onready var vBox = $"Container/VBoxContainer"

onready var mass_value = $Footer/mass_value
onready var max_mass_value = $Footer/max_mass_value

#var destinationMap={}

var ship:Ship

signal deliver(container)

func _ready():	
	hide()	

func update():
	if(self.visible):
		for n in vBox.get_children():
			vBox.remove_child(n)
			n.queue_free()
		var container = ship.inventory.getAllContainter()
		container.sort_custom(self,"_sortByDistance")
		print(container)
		for c in container:
			_add_container(c)
	#mass_value.text = str(ship.mass)
	

func _sortByDistance(a,b):	
	return a.getDistance() < b.getDistance()

func setPort(port:Port):
	self.inventor = port.inventory
	self.show()
	self.update()
	self.connect("deliver",port,"")
	port.inventory.connect("container_added", self, "_Inventory_added_container")

func clearPort(port:Port):
	self.inventor = null
	self.hide()
	self.disconnect("deliver",port,"")
	port.inventory.disconnect("container_added", self, "_Inventory_added_container")

func _Inventory_added_container(container:MissionContainer):
	update()

func _add_container(container:MissionContainer):	
	var newRaw = rawScene.instance()	
	newRaw.setContent(container)
	if(container.destination  == ship.docking_location):
		newRaw.connect("buttonPressed",self,"_on_buttonPressed")
	else:
		newRaw.disable()
	vBox.add_child(newRaw) # Add it as a child of this node.

func _on_buttonPressed(container:MissionContainer):
	emit_signal("deliver",container)	
	update()

func _on_visibility_changed():
	if(self.is_visible_in_tree()):
		update()
		max_mass_value.text  = str("%0.2f" % ship.getMaxStartMass())	
	pass
		
func setShip(ship:Ship):
	self.ship = ship
