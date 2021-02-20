extends nBody


export var turn_rate = 3
export var trust = 10

#func _physics_process(delta):	
	#_handle_inputs(delta)	
	
func _handle_inputs(delta):
	$Model.trust_forward_off()
	if Input.is_action_pressed("burn_forward"):	
		$Model.trust_forward_on()
		_burn_forward(delta)
		
	if Input.is_action_pressed("trun_left"):
		_rotation(delta,turn_rate)	
	
	if Input.is_action_pressed("turn_right"):
		_rotation(delta,turn_rate*-1)

func _rotation(delta, angle):
	rotate(Vector3(0,1,0),angle*delta)

func _get_forward_vector():
	var orientation = self.rotation.y
	var v = Vector3(0,0,1)
	v = v.rotated(Vector3(0,1,0), orientation)
	return v

func _burn_forward(delta):
	var force = _get_forward_vector()*trust
	velocety += force * delta
