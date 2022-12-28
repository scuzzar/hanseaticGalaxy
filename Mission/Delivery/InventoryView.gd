extends Panel

var ship:Ship

@onready var table : MissionTable = $MissionTable

func _ready():	

	hide()	

func update():
	var missions = _getMissions()	
	if(self.visible):
		$MissionTable.clear()
		var root = $MissionTable.create_item()
		missions.sort_custom(self._sortByDistance)		
		for m in missions:
			if m != null: 
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
		table.addContent(mission)

func _on_visibility_changed():
	if(self.is_visible_in_tree()):
		update()		
	pass
		
func setShip(ship:Ship):
	self.ship = ship
