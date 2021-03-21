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
	print("Destination:" + destination.name)	
