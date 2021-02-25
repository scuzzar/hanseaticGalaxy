extends Rigid_N_Body

export (Material) var material = preload("res://Bodys/Mars.material") 

func _ready():
	self.mode = MODE_KINEMATIC
	$Mesh.material_override = material
	self.simulation_delta_t = 3
	self.custom_integrator = true
	._ready()
	
func _integrate_forces(state):
	#Dont call that code!
	pass
	
func _physics_process(delta):
	self._leap_frog_integration(delta)
