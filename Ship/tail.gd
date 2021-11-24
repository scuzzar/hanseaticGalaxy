extends Control


onready var tracked_Node = self.get_parent()

export(NodePath) var frameOfReference_Node
onready var _frameOfReference = get_node_or_null(frameOfReference_Node)

var past = []
export var history_color = Color(0,1,0)
export var sim_color = Color(1,0,0)

var history = []
export var history_lenth = 100
export var history_update_interfall = 0.2
var history_update_timer = 0
var width = 1

func _process(delta):
	history_update_timer += delta
	#orbit._draw_list(simulation)
	if history_update_timer >= history_update_interfall:		
		history_update_timer -= history_update_interfall
		appendHistory()
	update()

func getPositionInFrame() -> Vector3:
	return tracked_Node.translation-_frameOfReference.global_transform.origin

func appendHistory():
	#if(g_force_strongest_Body_changed): history = []
	var new_relativ_point = getPositionInFrame()
	history.append(new_relativ_point)
	if(history.size()>history_lenth):
		history.pop_front()
	pass

func _draw():
	var now = [getPositionInFrame()]
	if(_frameOfReference!=null):
		var relativ_to = _frameOfReference.global_transform.origin
		if(history.size()>0): _draw_list(history + now ,relativ_to, history_color)	



func _draw_list(list, relativ_to, color):
	if(list.size()>1):
		for i in range(list.size()-1):
			var v1 = list[i]+relativ_to
			var v2 = list[i+1]+relativ_to
			if(!get_viewport().get_camera().is_position_behind(v1) and !get_viewport().get_camera().is_position_behind(v2)):
				var p1 = get_viewport().get_camera().unproject_position(v1)
				var p2 = get_viewport().get_camera().unproject_position(v2)
				if(get_viewport_rect().has_point(p2) or get_viewport_rect().has_point(p1)):
					draw_line(p1,p2,color,width,true)
	

func _on_reference_changed(old_body, new_body):
	print("now in SOI of" + str(new_body.name))
	history.clear()
	self._frameOfReference = new_body

func _stop(port:Port):
	history.clear()
	self.hide()
	self.set_process(false)

func _start(port:Port):
	self.show()
	self.set_process(true)
