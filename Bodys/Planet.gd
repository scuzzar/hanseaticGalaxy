tool
extends Rigid_N_Body

export (Material) var material = preload("res://Bodys/Mars.material") 


var draw_orbit_intervall  = 0.1
var orbitTimer = draw_orbit_intervall
var _start_SOI_distance = 0;
var _start_vel = 0;

func _ready():
	self.mode = MODE_KINEMATIC
	$Mesh.material_override = material
	self.custom_integrator = true
	._ready()
	if(!Engine.editor_hint and self.soi_node!=null):
		_start_SOI_distance = self.translation.distance_to(soi_node.translation)
		_start_vel = self.linear_velocity.length()

func _integrate_forces(state):	
	pass
	
func _physics_process(delta):
	if !Engine.editor_hint:
		self._leap_frog_integration(delta)
		#self.rotate_y(delta*self.angular_velocity.y*0.000001)

#func _updateOrbitDisplay():	
	#orbit._draw_list(simulation)
	#_print_SOI_Data()

func _print_SOI_Data():
	if(!Engine.editor_hint and self.soi_node!=null):
		var distance_str = String(self.translation.distance_to(soi_node.translation)-_start_SOI_distance)
		var vel_str = String(self.linear_velocity.length()-_start_vel)
		print(name + ": r=" + distance_str + "; v=" + vel_str)
