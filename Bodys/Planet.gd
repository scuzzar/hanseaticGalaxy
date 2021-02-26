tool
extends Rigid_N_Body

export (Material) var material = preload("res://Bodys/Mars.material") 

var orbit
var draw_orbit_intervall  = 0.5
var orbitTimer = draw_orbit_intervall

func _ready():
	self.mode = MODE_KINEMATIC
	$Mesh.material_override = material
	self.simulation_delta_t = 3
	self.custom_integrator = true
	._ready()
	orbit = preload("res://N_Body/3DOrbit.gd").new()
	orbit.ship = self
	self.add_child(orbit)
	print("Planetread")
	
	
func _process(delta):
	._process(delta)
	orbitTimer -= delta
	if(orbitTimer<=0):
		orbitTimer = draw_orbit_intervall
		_updateOrbitDisplay()

func _integrate_forces(state):
	
	pass
	
func _physics_process(delta):
	if !Engine.editor_hint:
		self._leap_frog_integration(delta)

func _updateOrbitDisplay():	
	orbit._draw_list(simulation)
