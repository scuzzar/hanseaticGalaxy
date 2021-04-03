extends Spatial

class_name MissionContainer

var destination :Node
var origin :Node

var loaded = false
var reward = 100

enum GOOD{
	METALS,
	FOOD,
	MACHINES,
	ELECTRONICS,
	CONSUMERS,
	RARE_METALS,
	LUXUS
}

export(GOOD) var good  

signal clicked(sender)

func _ready():
	_set_good(good)

func _on_input_event(camera, event, click_position, click_normal, shape_idx):
	if(event is InputEventMouseButton and event.is_pressed()):
		print("hit")
		emit_signal("clicked",self)	

func _on_mouse_entered():
	if(self.get_tree()!=null): self.get_tree().get_nodes_in_group("consol")[0].text = destination.name
	print("Destination:" + destination.name)	


func _on_mouse_exited():
	if(self.get_tree()!=null): 	self.get_tree().get_nodes_in_group("consol")[0].text = ""

func _set_good(good):
	$Mesh/Metals.hide()
	$Mesh/Food.hide()
	$Mesh/Machines.hide()
	$Mesh/Electronics.hide()
	$Mesh/ConsomerGoods.hide()
	$Mesh/RareMetal.hide()
	$Mesh/LuxusGoods.hide()
	
	
	match good:
		GOOD.METALS:
			$Mesh/Metals.show()
		GOOD.FOOD:
			$Mesh/Food.show()
		GOOD.MACHINES:
			$Mesh/Machines.show()
		GOOD.ELECTRONICS:
			$Mesh/Electronics.show()
		GOOD.CONSUMERS:
			$Mesh/ConsomerGoods.show()
		GOOD.RARE_METALS:
			$Mesh/RareMetal.show()
		GOOD.LUXUS:
			$Mesh/LuxusGoods.show()
			
