extends Spatial

class_name MissionContainer

var destination :Spatial
var origin :Spatial

var loaded = false


enum CARGO{
	METALS = 0,
	FOOD = 1,
	ICE = 2,
	WATER = 3,	
	OXYGEN = 4,
	MACHINES = 5,
	HABITATION = 6,
	INFRASTRUCTURE = 7,
	STEEL = 8,
	ELECTRONICS = 9,
	CONSUMERS = 10,
	RARE_METALS = 11,
	LUXUS = 12,
	DEUTERIUM = 13,
	FUEL = 14
}
var reward = 0
#const price ={
#	CARGO.METALS:2000,
#	CARGO.FOOD:850,
#	CARGO.ICE:1500,
#	CARGO.WATER:1800,
#	CARGO.OXYGEN:1000,
#	CARGO.MACHINES:1700,
#	CARGO.HABITATION:3500,
#	CARGO.INFRASTRUCTURE:4000,
#	CARGO.STEEL:100,
#	CARGO.ELECTRONICS:1000,
#	CARGO.CONSUMERS:900,
#	CARGO.RARE_METALS:2500,
#	CARGO.LUXUS:1400,
#	CARGO.DEUTERIUM:2300,
#	CARGO.FUEL:1500
#}

#const names ={
#	CARGO.METALS:"Metals",
#	CARGO.FOOD:"Food",
#	CARGO.MACHINES:"Machines",
#	CARGO.ELECTRONICS:"Electronics",
#	CARGO.CONSUMERS:"ConsumerGoods",
#	CARGO.RARE_METALS:"RareMetals",
#	CARGO.LUXUS:"Luxus",
#	CARGO.FUEL:"Fuel",
#	CARGO.ICE:"Ice",
#	CARGO.WATER:"Water",
#	CARGO.OXYGEN:"Oxygen",
#	CARGO.HABITATION:"Habitation",
#	CARGO.INFRASTRUCTURE:"Infrastructure",
#	CARGO.STEEL:"Steel",
#	CARGO.DEUTERIUM:"Deuterium"
#}

#const mass ={
#	CARGO.METALS:20,
#	CARGO.FOOD:4,
#	CARGO.MACHINES:15,
#	CARGO.ELECTRONICS:8,
#	CARGO.CONSUMERS:6,
#	CARGO.RARE_METALS:18,
#	CARGO.LUXUS:5,
#	CARGO.FUEL:0,
#	CARGO.ICE:14,
#	CARGO.WATER:15,
#	CARGO.OXYGEN:4,
#	CARGO.HABITATION:25,
#	CARGO.INFRASTRUCTURE:30,
#	CARGO.STEEL:25,
#	CARGO.DEUTERIUM:8
#}

const ContainerTyp = preload("res://Container/containerTyps.csv").records

export(CARGO) var cargo  

signal clicked(sender)

func _ready():
	_set_cargo(cargo)	

func _on_input_event(camera, event, click_position, click_normal, shape_idx):
	if(event is InputEventMouseButton and event.is_pressed() ):
		#event = event as InputEventMouseButton
		if(event.button_index == 1):
			emit_signal("clicked",self)	

func _on_mouse_entered():	
	if(self.get_tree()!=null): self.get_tree().get_nodes_in_group("consol")[0].text = str(self)
	
func _to_string()->String:
	if(destination!=null):
	#var text = "Destination: " + destination.name + " (" + str(self.reward) +"c) " + str(round(getDistance())) + "km"
		return  getCargoName() + " > " + destination.name + " C:" + str(self.reward) +" MASS:" + str(self.getMass()) #+ " D:" + str(getDistance()) 
	else:
		return "nullDestination"

func getPrice()-> int:
	return ContainerTyp[cargo]["price"]

func getCargoName()-> String:
	return ContainerTyp[cargo]["name"]

func getDistance()->float:
	if(origin==null or destination==null): return 0.0	
	return origin.global_transform.origin.distance_to(destination.global_transform.origin) 

func getMass()->float:
	return ContainerTyp[cargo]["mass"]

func _on_mouse_exited():
	if(self.get_tree()!=null): 	self.get_tree().get_nodes_in_group("consol")[0].text = ""

func _set_cargo(pcargo):
	self.cargo = pcargo
	$Mesh/Metals.hide()
	$Mesh/Food.hide()
	$Mesh/Machines.hide()
	$Mesh/Electronics.hide()
	$Mesh/ConsomerGoods.hide()
	$Mesh/RareMetal.hide()
	$Mesh/LuxusGoods.hide()
	
	
	match cargo:
		CARGO.METALS:
			$Mesh/Metals.show()
		CARGO.FOOD:
			$Mesh/Food.show()
		CARGO.MACHINES:
			$Mesh/Machines.show()
		CARGO.ELECTRONICS:
			$Mesh/Electronics.show()
		CARGO.CONSUMERS:
			$Mesh/ConsomerGoods.show()
		CARGO.RARE_METALS:
			$Mesh/RareMetal.show()
		CARGO.LUXUS:
			$Mesh/LuxusGoods.show()
		CARGO.ICE:
			$Mesh/Machines.show()
		CARGO.WATER:
			$Mesh/Machines.show()
		CARGO.OXYGEN:
			$Mesh/Machines.show()
		CARGO.HABITATION:
			$Mesh/Electronics.show()
		CARGO.INFRASTRUCTURE:
			$Mesh/Electronics.show()
		CARGO.STEEL:
			$Mesh/Metals.show()
		CARGO.DEUTERIUM:
			$Mesh/RareMetal.show()
			

func save():	
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"destination" : destination.get_path(),
		"origin" : origin.get_path(),
		"cargo" : cargo,
		"reward" : reward
			
	}
	return save_dict

func load_save(dict):	
	_set_cargo( CARGO.values()[dict["cargo"]])
	reward = dict["reward"]
	destination = get_node(dict["destination"])
	origin = get_node(dict["origin"])
	pass
