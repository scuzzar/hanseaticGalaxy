tool
extends ImmediateGeometry

export var g_color = Color(0,0,1)

var v1 = Vector3(0,0,0)
var v2 = Vector3(100,0,0)
var v3 = Vector3(100,100,0)

func _ready():
	pass
	
onready var ship = self.get_parent()

var past = []
export var history_color = Color(0,1,0)
export var g_comp_color = Color(0,0,1)
export var sim_color = Color(1,0,0)


var width = 1
export var gravety_sum = false
export var gravety_components = true

func _process(delta):
	if ship == null : ship = get_parent()
	#ship.simulate()
	var now = [ship.translation]	
	#if(ship.history_lenth>0): _draw_list(ship.history + now, history_color)
	#if(gravety_sum): _draw_gravety_sum()
	#if(gravety_components): _draw_gravety_components()
	#if(ship.simulation_steps>0): _draw_list(ship.simulation,sim_color)

#func _draw_gravety_components():
#	for comp in ship.Gravety_acceleration_components:		
#		var v1 = get_viewport().get_camera().unproject_position(ship.translation)
#		var v2 = get_viewport().get_camera().unproject_position(ship.translation+comp)
#		draw_line(v1,v2,g_comp_color,width,true)

#func _draw_gravety_sum():
#	var v1 = get_viewport().get_camera().unproject_position(ship.translation)
#	var v2 = get_viewport().get_camera().unproject_position(ship.translation+ship.Gravety_acceleration_sum)
#	draw_line(v1,v2,g_color,width,true)


func draw_list(list):
	clear()
	begin(Mesh.PRIMITIVE_LINE_STRIP)
	if(list.size()>1):
		for i in range(list.size()-1):
			print(list[i])
			add_vertex(ship.transform.affine_inverse() * list[i] )				
	end()

