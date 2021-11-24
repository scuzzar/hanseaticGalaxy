extends Panel

var rawScene = preload("res://Container/CargoMissions/raw.tscn")
onready var vBox = $"Container/VBoxContainer"

var destinationMap={}

var inventor
signal accepted(container)

func _ready():	
	hide()
	pass 

func update():
	if(self.visible):
		for n in vBox.get_children():
			vBox.remove_child(n)
			n.queue_free()
		var container = inventor.getAllContainter()
		container.sort_custom(self,"_sortByDistance")
		for c in container:
			_add_container(c)		

func _sortByDistance(a,b):	
	return a.getDistance() < b.getDistance()

func setPort(port:Port):
	self.inventor = port.inventory
	self.show()
	self.update()
	self.connect("accepted",port,"_on_container_clicked")
	port.inventory.connect("container_added", self, "_Inventory_added_container")

func clearPort(port:Port):
	self.inventor = null
	self.hide()
	self.disconnect("accepted",port,"_on_container_clicked")
	port.inventory.disconnect("container_added", self, "_Inventory_added_container")

func _Inventory_added_container(container:MissionContainer):
	update()

func _add_container(container:MissionContainer):	
	var newRaw = rawScene.instance()	
	newRaw.setContent(container)
	newRaw.connect("accepted",self,"_on_accepted")
	vBox.add_child(newRaw) # Add it as a child of this node.

func _on_accepted(container:MissionContainer):
	emit_signal("accepted",container)
	update()

func _on_visibility_changed():
	if(self.is_visible_in_tree()):
		update()
