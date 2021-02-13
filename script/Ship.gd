extends RigidBody

func _ready():
	pass # Replace with function body.


func _integrate_forces(state):
	if Input.is_action_just_pressed("burn_forward"):		
		var force = Vector3(10,0,0)
		state.add_force(force, Vector3(0,0,0))
