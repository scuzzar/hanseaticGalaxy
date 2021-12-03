extends Spatial

class_name Warft
onready var orbit_radius = translation.length()

var angle = 0
var angular_speed = 0 
var docked_ship = null
onready var inventory = $Inventory 

func _ready():
	var r = orbit_radius
	var G = Globals.G
	var M = get_parent().mass
	var kosmic = sqrt(G*M/r)
	
	if(orbit_radius>0.5):
		angular_speed = 2*PI/(2*PI*orbit_radius/kosmic)	
		angle = asin(translation.x/orbit_radius)	
		var start = translation
		var result = [start]


func _process(delta):
	angle += (angular_speed *delta)		
	if(angle >= 2*PI): angle -= 2*PI
	self.translation = Vector3(sin(angle)*orbit_radius,0,cos(angle)*orbit_radius)
	if(docked_ship!=null):
		docked_ship.transform.origin = self.global_transform.origin

func _on_Area_body_entered(body):
	if(body is Ship):		
		self._on_Area_Ship_enterd(body)

func _on_Area_body_exited(body):
	if(body is Ship):		
		self._on_Area_Ship_exited(body)

func _on_Area_Ship_enterd(ship : Ship):
	#ship.dock(self)
	if(docked_ship==null):
		self.docked_ship = ship	
		ship.dock(self)
		Player.pay(ship.get_refule_costs())
		ship.set_fuel(ship.fuel_cap)
		ship.transform.origin = self.global_transform.origin
		#ship.velocety = Vector3(0,0,0) 
		print_debug("ship landed")
	
func _on_Area_Ship_exited(ship : Ship):
	print_debug("ship started")

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),		
		"angle" : angle,
		"angular_speed" : angular_speed,
		"orbit_radius" : orbit_radius
	}
	return save_dict

func load_save(dict):
	angle=dict["angle"]
	orbit_radius=dict["orbit_radius"]
	angular_speed = dict["angular_speed"]
	
