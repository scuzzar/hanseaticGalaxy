extends nBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var turn_rate = 3
export var trust = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _physics_process(delta):
#	$Model.trust_forward_off()
#	if Input.is_action_pressed("burn_forward"):	
#		$Model.trust_forward_on()
#		_burn_forward(delta)
#	
	
#	if Input.is_action_pressed("trun_left"):
#		_rotation(delta,turn_rate)	
#	
#	if Input.is_action_pressed("turn_right"):
#		_rotation(delta,turn_rate*-1)

func _rotation(delta, angle):
	rotate(Vector3(0,1,0),angle*delta)
	

func _get_forward_vector():
	var orientation = self.rotation.y
	var v = Vector3(0,0,-1)
	v = v.rotated(Vector3(0,1,0), orientation)
	return v

func _burn_forward(delta):
	var force = _get_forward_vector()*trust
	velocety += force * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
