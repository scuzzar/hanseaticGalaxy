tool
extends ImmediateGeometry

func _ready():
	self.material_override = load("res://N_Body/OrbitMaterial.tres")
	pass

export var sim_color = Color(1,0,0)

var width = 1

func draw_list(list):
	clear()
	begin(Mesh.PRIMITIVE_LINE_STRIP)	
	if(list.size()>1):
		for i in range(list.size()-1):		
			var p = list[i]
			self.set_color(sim_color)
			add_vertex(p)
	end()

