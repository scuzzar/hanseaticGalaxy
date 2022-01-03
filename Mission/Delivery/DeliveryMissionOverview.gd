extends Panel

var rawScene = preload("res://Mission/Delivery/DeliveryRaw.tscn")
onready var vBox = $"Container/VBoxContainer"

#var destinationMap={}

var ship:Ship


signal deliver(container)
signal about(container)

func _ready():	
	
	hide()	

func update():
	var missions = _getMissions()	
	if(self.visible):
		for n in vBox.get_children():
			vBox.remove_child(n)
			n.queue_free()		
		missions.sort_custom(self,"_sortByDistance")		
		for m in missions:
			_add_mission(m)
	#mass_value.text = str(ship.mass)
	

func _getMissions():
	return Player.get_accepted_delivery_Missions()

func _sortByDistance(a,b):	
	if(a == null or b == null): return false
	return a.getDistance() < b.getDistance()

func _Inventory_added_container(container:CargoContainer):
	update()

func _add_mission(mission:DeliveryMission):	
	if(mission!=null):
		var newRaw = rawScene.instance()	
		newRaw.setContent(mission)
		if(mission.destination  == ship.docking_location):
			newRaw.setButtonActon("Deliver")
			newRaw.connect("buttonPressed",self,"_on_deliver")
		else:
			newRaw.setButtonActon("About")
			newRaw.connect("buttonPressed",self,"_on_about")
		vBox.add_child(newRaw) # Add it as a child of this node.

func _on_deliver(container:DeliveryMission):
	emit_signal("deliver",container)
	$Cash.play()	
	update()

func _on_about(container:DeliveryMission):
	emit_signal("about",container)

func _on_visibility_changed():
	if(self.is_visible_in_tree()):
		update()		
	pass
		
func setShip(ship:Ship):
	self.ship = ship
