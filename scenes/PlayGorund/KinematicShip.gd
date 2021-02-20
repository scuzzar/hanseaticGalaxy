extends KinematicBody

export var turn_rate = 3
export var trust = 10

var Gravety_acceleration_sum : Vector3
var Gravety_acceleration_components : Array

export var mass = 200

export var velocety = Vector3(9,0,0)

var g_force = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	g_force = Universe.g_force(translation)

func _physics_process(delta):
	#g_force = Universe.g_force(self.translation)
	velocety += g_force * delta / mass / 2
	
	#self.translation += velocety * delta
	
	#move_and_slide(velocety*delta)
	
	print(move_and_collide(velocety*delta))
	
	g_force = Universe.g_force(self.translation)
	velocety += g_force * delta / mass / 2
	
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
	var v = Vector3(0,0,-1)
	v = v.rotated(Vector3(0,1,0), orientation)
	return v

func _burn_forward(delta):
	var force = _get_forward_vector()*trust
	velocety += force * delta
