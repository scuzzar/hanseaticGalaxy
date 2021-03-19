extends Spatial

class_name MissionContainer

export(NodePath) var destination_path
var destination : Port

export(NodePath) var origin_path
var origin : Port

onready var ship = get_node_or_null("/root/Sol/Ship")

var loaded = false

func _ready():
	destination = get_node_or_null(destination_path)
	origin = get_node_or_null(origin_path)
	assert(destination is Port)
	assert(origin is Port)
	

func load(s : Ship):
	self.get_parent().remove_child(self)
	s.add_child(self)
	print(self.translation)
	self.translation = Vector3(0,0,-3)
	print(destination.name)
	print(self.translation)
	loaded = true


func _on_input_event(camera, event, click_position, click_normal, shape_idx):
	if(event is InputEventMouseButton and event.is_pressed()):
		print("hit")
		self.load(ship)		
