@tool
extends ImmediateMesh 

class_name SimplePlanetOrbit

var planet : simpelPlanet

func _ready():
	self.material_override = load("res://N_Body/OrbitMaterial.tres")
	if get_parent() is simpelPlanet:
		planet = get_parent() as simpelPlanet
	else :
		push_error(get_parent().name + " is not a simple Planet, turning 3D Orbit OFF!")
		self.set_process(false)
	pass

@export var sim_color = Color(1,0,0)

var width = 1

func _process(delta):
	self.update_orbit()	

func update_orbit():	
	clear()	
	var start = planet.predictGlobalPosition(0)
	var result = [start]
	
	for i in range(3000): 
		start = planet.predictGlobalPosition(i)	
		result.append(start)		
	draw_list(result)

func draw_list(list):
	clear()
	begin(Mesh.PRIMITIVE_LINE_STRIP)	
	if(list.size()>1):
		for i in range(list.size()-1):		
			var p = list[i]
			self.set_color(sim_color)
			add_vertex(p)
	end()

