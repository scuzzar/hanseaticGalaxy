extends Node3D

class_name CargoContainer
var loaded = false

var cargo  

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
	return Typ.Cargo[cargo]["price"]

func getCargoName()-> String:
	return Typ.Cargo[cargo]["name"]


func getMass()->float:
	return Typ.Cargo[cargo]["mass"]

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
		Typ.CARGO.METALS:
			$Mesh/Metals.show()
		Typ.CARGO.FOOD:
			$Mesh/Food.show()
		Typ.CARGO.MACHINES:
			$Mesh/Machines.show()
		Typ.CARGO.ELECTRONICS:
			$Mesh/Electronics.show()
		Typ.CARGO.CONSUMERS:
			$Mesh/ConsomerGoods.show()
		Typ.CARGO.RARE_METALS:
			$Mesh/RareMetal.show()
		Typ.CARGO.LUXUS:
			$Mesh/LuxusGoods.show()
		Typ.CARGO.ICE:
			$Mesh/Machines.show()
		Typ.CARGO.WATER:
			$Mesh/Machines.show()
		Typ.CARGO.OXYGEN:
			$Mesh/Machines.show()
		Typ.CARGO.HABITATION:
			$Mesh/Electronics.show()
		Typ.CARGO.INFRASTRUCTURE:
			$Mesh/Electronics.show()
		Typ.CARGO.STEEL:
			$Mesh/Metals.show()
		Typ.CARGO.DEUTERIUM:
			$Mesh/RareMetal.show()
		Typ.CARGO.ENERGY:
			$Mesh/Electronics.show()
			

#func save():	
#	var save_dict = {
#		"filename" : get_filename(),
#		"parent" : get_parent().get_path(),
#		"cargo" : cargo
#	}
#	return save_dict

#func load_save(dict):	
#	_set_cargo( CARGO.values()[dict["cargo"]])
#	pass
