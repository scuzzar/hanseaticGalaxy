extends Control


onready var ship = self.get_parent()

var past = []
export var history_color = Color(0,1,0)
export var sim_color = Color(1,0,0)
export var show_sim = false
export var show_history = false

var width = 1

func _draw():
	var now = [ship.translation]
	if(show_history and ship.history.size()>0): _draw_list(ship.history + now, history_color)	
	if(show_sim and ship.simulation_pos.size()>0): _draw_list(ship.simulation_pos,sim_color)

func _draw_list(list, color):
	if(list.size()>1):
		for i in range(list.size()-1):
			if(!get_viewport().get_camera().is_position_behind(list[i]) and !get_viewport().get_camera().is_position_behind(list[i+1])):
				var v1 = get_viewport().get_camera().unproject_position(list[i])
				var v2 = get_viewport().get_camera().unproject_position(list[i+1])
				if(get_viewport_rect().has_point(v2) or get_viewport_rect().has_point(v1)):
					draw_line(v1,v2,color,width,true)

func _process(delta):
	update()

