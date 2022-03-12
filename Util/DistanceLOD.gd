extends Node

@onready var cam = $"/root/Sol/Camera"

@export var active = true
@export var draw_distance = 10000
var draw_distance_sqr = draw_distance*draw_distance

func _process(delta):
	var parent = get_parent()
	var d_sqr = parent.global_transform.origin.distance_squared_to(cam.global_transform.origin)
	if(d_sqr>draw_distance_sqr):
		parent.hide()
		pass
	else:		
		parent.show()
