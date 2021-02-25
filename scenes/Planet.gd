extends Rigid_N_Body

export(Material) var material = preload("res://Bodys/Mars.material")

func _ready():
	$Mesh.material_override = material
	self.simulation_delta_t = 10
	._ready()
