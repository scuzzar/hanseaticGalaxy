extends Rigid_N_Body

export var turn_rate = 3
export var trust = 100
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _integrate_forces(state):
	._integrate_forces(state)
	$Model.trust_forward_off()
	if Input.is_action_pressed("burn_forward"):	
		$Model.trust_forward_on()
		_burn_forward(state)
	
	_rotation(state,0)
	if Input.is_action_pressed("trun_left"):
		_rotation(state,turn_rate)	
	
	if Input.is_action_pressed("turn_right"):
		_rotation(state,turn_rate*-1)
		
	
func _rotation(state, angle):
	state.set_angular_velocity(Vector3(0,angle,0))

func _get_forward_vector():
	var orientation = self.rotation.y
	var v = Vector3(0,0,-1)
	v = v.rotated(Vector3(0,1,0), orientation)
	return v

func _burn_forward(state):
	var force = _get_forward_vector()*trust
	state.add_force(force, Vector3(0,0,0))