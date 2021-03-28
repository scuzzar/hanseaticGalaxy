extends RigidBody

class_name simpelBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var radius = translation.length()
var isGravetySource = true
var orbit
var angle = 0
export var orbital_speed = 1
onready var angular_speed = 2*PI/(2*PI*radius/orbital_speed)

func _enter_tree():
	self.add_to_group("bodys")
	self.gravity_scale = 0
	orbit = preload("res://N_Body/3DOrbit.gd").new()	
	self.get_parent().call_deferred("add_child", orbit)

# Called when the node enters the scene tree for the first time.
func _ready():
	isGravetySource = true
	
	
func _physics_process(delta):
	self.translation = Vector3(sin(angle)*radius,0,cos(angle)*radius)
	angle += (angular_speed *delta)
	if(angle >= 2*PI): angle -= 2*PI
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
