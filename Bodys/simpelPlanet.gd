tool
extends RigidBody

class_name simpelBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (Material) var material = preload("res://Bodys/Mars.material") 

onready var orbit_radius = translation.length()
var isGravetySource = true
var orbit
var angle = 0
export var orbital_speed = 1
export var show_orbit = false setget set_show_orbit
export var radius:float = 6371
export(float) var surface_g = 5
var angular_speed = 0 



func _enter_tree():
	self.add_to_group("bodys")
	self.gravity_scale = 0
	orbit = preload("res://N_Body/3DOrbit.gd").new()	
	self.get_parent().call_deferred("add_child", orbit)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Shape/Mesh.material_override = material
	isGravetySource = true
	
	var s = radius/6371.0*68	
	$Shape.scale = Vector3(s,s,s)
	
	
	
	var r = $Shape/Mesh.get_aabb().get_longest_axis_size()*s/2
	#var g = 50 *self.mass  /(r*r)
	mass = (surface_g*r*r)/50
	
	#var surface_g_force = 
	
	if(orbit_radius>0.5):
		angular_speed = 2*PI/(2*PI*orbit_radius/orbital_speed)	
		angle = asin(translation.x/orbit_radius)	
		var start = translation
		var result = [start]
	

func _physics_process(delta):
	if !Engine.editor_hint:	
		angle += (angular_speed *delta)	
		if(angle >= 2*PI): angle -= 2*PI
		self.translation = Vector3(sin(angle)*orbit_radius,0,cos(angle)*orbit_radius)
		

func set_show_orbit(value):
	show_orbit = value
	if(orbit!=null):
		orbit.clear()
		if(show_orbit):
			var start = translation
			var result = [start]
			for i in range(360):
				var a = 2*PI/360*i
				start = Vector3(sin(a)*orbit_radius,0,cos(a)*orbit_radius)
				result.append(start)		
			orbit.draw_list(result)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
