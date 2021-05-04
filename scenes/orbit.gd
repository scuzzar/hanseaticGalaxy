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
	var relativ_to = ship.last_g_force_strongest_Body.global_transform.origin
	if(show_history and ship.history.size()>0): _draw_list(ship.history ,relativ_to, history_color)	
	if(show_sim and ship.simulation_pos.size()>0): _draw_list(ship.simulation_pos,relativ_to,sim_color)

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

func _process(delta):
	update()

