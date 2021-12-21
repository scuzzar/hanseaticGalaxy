extends Spatial

class_name CargoContainer
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
	FUEL = 14,
	ENERGY = 15,
	NONE = 999
}

const ContainerTyp = preload("res://Cargo/containerTyps.csv").records

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
	


func getPrice()-> int:
	return ContainerTyp[cargo]["price"]

func getCargoName()-> String:
	return ContainerTyp[cargo]["name"]


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
		CARGO.ENERGY:
			$Mesh/Electronics.show()
			

func save():	
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"cargo" : cargo
	}
	return save_dict

func load_save(dict):	
	_set_cargo( CARGO.values()[dict["cargo"]])
	pass
