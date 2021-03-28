tool
extends RigidBody

class_name simpelBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (Material) var material = preload("res://Bodys/Mars.material") 

onready var radius = translation.length()
var isGravetySource = true
var orbit
var angle = 0
export var orbital_speed = 1
export var show_orbit = false setget set_show_orbit
var angular_speed = 0 

func _enter_tree():
	self.add_to_group("bodys")
	self.gravity_scale = 0
	orbit = preload("res://N_Body/3DOrbit.gd").new()	
	self.get_parent().call_deferred("add_child", orbit)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Mesh.material_override = material
	isGravetySource = true
	if(radius>0.5):
		angular_speed = 2*PI/(2*PI*radius/orbital_speed)	
		angle = acos(translation.z/radius)
		var start = translation
		var result = [start]
		for i in range(360):
			var a = 2*PI/360*i
			start = Vector3(sin(a)*radius,0,cos(a)*radius)
			result.append(start)		
		orbit.draw_list(result)
		orbit.hide()

func _process(delta):
	if Engine.editor_hint:	
		if(show_orbit):
			orbit.show()
		else:
			orbit.hide()
	
func _physics_process(delta):
	if !Engine.editor_hint:		
		self.translation = Vector3(sin(angle)*radius,0,cos(angle)*radius)
		angle += (angular_speed *delta)
		if(angle >= 2*PI): angle -= 2*PI

func set_show_orbit(value):
	show_orbit = value
	if(orbit!=null):
		orbit.clear()
		if(show_orbit):
			var start = translation
			var result = [start]
			for i in range(360):
				var a = 2*PI/360*i
				start = Vector3(sin(a)*radius,0,cos(a)*radius)
				result.append(start)		
			orbit.draw_list(result)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
