extends Control

@export var color = Color(0,1,0)

var path = []
var width = 1

func _process(delta):
	update()

func _draw():
	if(path.size()>0): _draw_list(path ,Vector3(0,0,0), color)	

func _draw_list(list, relativ_to, color):
	if(list.size()>1):
		for i in range(list.size()-1):
			var v1 = list[i]+relativ_to
			var v2 = list[i+1]+relativ_to
			if(!get_viewport().get_camera().is_position_behind(v1) and !get_viewport().get_camera().is_position_behind(v2)):
				var p1 = get_viewport().get_camera().unproject_position(v1)
				var p2 = get_viewport().get_camera().unproject_position(v2)
				if(get_viewport_rect().has_point(p2) or get_viewport_rect().has_point(p1)):
					draw_line(p1,p2,color,width)
	

func _on_reference_changed(old_body, new_body):
	print("now in SOI of" + str(new_body.name))
	path.clear()
	self._frameOfReference = new_body

func _stop(port:Port):
	path.clear()
	self.hide()
	self.set_process(false)

func _start(port:Port):
	self.show()
	self.set_process(true)
