extends Spatial

class_name MissionContainer

var destination :Node
var origin :Node

var loaded = false
var reward = 100

signal clicked(sender)

func _on_input_event(camera, event, click_position, click_normal, shape_idx):
	if(event is InputEventMouseButton and event.is_pressed()):
		print("hit")
		emit_signal("clicked",self)	

func _on_mouse_entered():
	if(self.get_tree()!=null): self.get_tree().get_nodes_in_group("consol")[0].text = destination.name
	print("Destination:" + destination.name)	


func _on_mouse_exited():
	if(self.get_tree()!=null): 	self.get_tree().get_nodes_in_group("consol")[0].text = ""
