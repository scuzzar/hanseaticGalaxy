extends Port

class_name SpaceStation

func _ready():
	self.name = self.get_parent().name
	$Lable3D.text = self.get_parent().name

func _physics_process(delta):
	if(docked_ship!=null):
		docked_ship.transform.origin = self.global_transform.origin
func _on_Area_Ship_enterd(ship : Ship):	
	if(docked_ship==null):
		self.docked_ship = ship	
		ship.dock(self)
		Player.pay(ship.get_refule_costs())
		ship.set_fuel(ship.fuel_cap)
		
		ship.connect("undocked",self,"on_ship_undocked")
		print_debug("ship landed")


func on_ship_undocked(target:Port):
	docked_ship.disconnect("undocked",self,"on_ship_undocked")
	self.docked_ship = null
	print_debug("ship started")
