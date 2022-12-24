@tool
extends MeshInstance3D

@export
var bodyPos : PackedVector3Array

@export
var bodyMass : PackedFloat32Array

var bodys

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_Bodys()

func _update_Bodys():
	bodys = get_tree().get_nodes_in_group("bodys")
	bodyPos = []
	bodyMass = []
	for body in bodys:
		if(body.isGravetySource):
			bodyPos.append(body.get_parent().to_global(body.position));
			bodyMass.append(body.mass)	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):	
	_update_Bodys()
	
	var mat: ShaderMaterial
	mat = self.mesh.surface_get_material(0)
	
	mat.set_shader_parameter("n_bodys", bodyPos.size())
	
	mat.set_shader_parameter("bodysPos", bodyPos)
	mat.set_shader_parameter("bodyMass", bodyMass)
	
	#rotate(Vector3(0,1,0),delta)

