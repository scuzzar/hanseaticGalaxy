extends Rigid_N_Body

export(Material) var material = preload("res://Bodys/Mars.material")

func _ready():
	._ready()
	$Mesh.material_override = material
