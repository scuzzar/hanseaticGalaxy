extends Spatial

class_name MissionContainer

var destination :Node
var origin :Node

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
	CARGO.METALS:100,
	CARGO.FOOD:150,
	CARGO.MACHINES:500,
	CARGO.ELECTRONICS:800,
	CARGO.CONSUMERS:200,
	CARGO.RARE_METALS:350,
	CARGO.LUXUS:1400
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
	if(self.get_tree()!=null): self.get_tree().get_nodes_in_group("consol")[0].text = destination.name
	print("Destination:" + destination.name)	

func getPrice()-> int:
	return price[cargo]

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
			
