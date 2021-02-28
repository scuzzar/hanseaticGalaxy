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
	var now = [ship.translation]	


func draw_list(list):
	clear()
	begin(Mesh.PRIMITIVE_LINE_STRIP)
	if(list.size()>1):
		for i in range(list.size()-1):
			#var p = ship.transform.affine_inverse() * list[i]
			var p = list[i]
			add_vertex(p)
	end()

