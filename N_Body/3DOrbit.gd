tool
extends ImmediateGeometry

func _ready():
	self.material_override = load("res://N_Body/OrbitMaterial.tres")
	pass
	
#onready var body = self.get_parent()

export var sim_color = Color(1,0,0)


var width = 1
#export var gravety_sum = false
#export var gravety_components = true

#func _process(delta):
#	if body == null : body = get_parent()
#	var now = [body.translation]	


func draw_list(list):
	clear()
	begin(Mesh.PRIMITIVE_LINE_STRIP)	
	if(list.size()>1):
		for i in range(list.size()-1):		
			var p = list[i]
			self.set_color(sim_color)
			add_vertex(p)
	end()

