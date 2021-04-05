extends Spatial

class_name MissionContainer

var destination :Spatial
var origin :Spatial

var loaded = false


enum CARGO{
	METALS,
	FOOD,
	MACHINES,
	ELECTRONICS,
	CONSUMERS,
	RARE_METALS,
	LUXUS
}
var reward = 0
var price ={
	CARGO.METALS:2000,
	CARGO.FOOD:400,
	CARGO.MACHINES:1700,
	CARGO.ELECTRONICS:1000,
	CARGO.CONSUMERS:900,
	CARGO.RARE_METALS:2500,
	CARGO.LUXUS:1400
}

var names ={
	CARGO.METALS:"Metals",
	CARGO.FOOD:"Food",
	CARGO.MACHINES:"Machines",
	CARGO.ELECTRONICS:"Electronics",
	CARGO.CONSUMERS:"ConsumerGoods",
	CARGO.RARE_METALS:"RareMetals",
	CARGO.LUXUS:"Luxus"
}

var mass ={
	CARGO.METALS:20,
	CARGO.FOOD:5,
	CARGO.MACHINES:15,
	CARGO.ELECTRONICS:8,
	CARGO.CONSUMERS:6,
	CARGO.RARE_METALS:18,
	CARGO.LUXUS:5
}

export(CARGO) var cargo  

signal clicked(sender)

func _ready():
	_set_cargo(cargo)

func _on_input_event(camera, event, click_position, click_normal, shape_idx):
	if(event is InputEventMouseButton and event.is_pressed()):
		print("hit")
		emit_signal("clicked",self)	

func _on_mouse_entered():	
	if(self.get_tree()!=null): self.get_tree().get_nodes_in_group("consol")[0].text = str(self)
	
func _to_string()->String:
	if(destination!=null):
	#var text = "Destination: " + destination.name + " (" + str(self.reward) +"c) " + str(round(getDistance())) + "km"
		return  getCargoName() + " >    " + destination.name + "    C:" + str(self.reward) +"    MASS:" + str(self.getMass())
	else:
		return "nullDestination"

func getPrice()-> int:
	return price[cargo]

func getCargoName()-> String:
	return names[cargo]

func getDistance()->float:
	if(origin==null or destination==null): return 0.0	
	return origin.global_transform.origin.distance_to(destination.global_transform.origin) 

func getMass()->float:
	return mass[cargo]

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
			
