extends Spatial

@onready var ship:Ship = get_node("../PlayerShip")
@onready var tilt:Spatial = $TiltAxis
@onready var camera:Camera = $TiltAxis/Camera

@export var min_zoom := 0.5
@export var max_zoom := 20000
@export var zoom_factor := 1
@export var zoom_factor_factor := 0.2
@export var zoom_duration := 0.2

@export var rotation_speed := 0.5

var storedFreeRotation = Vector3(0,0,0)

enum STATE{
	LANDED,
	PLANET,
	SUN,
	FREE
}

@export var state = STATE.PLANET

var _zoom_level = 1.0 

@onready var tween: Tween = $ZoomTween

var _next_rotation = Vector2(0,0)

func _ready():
	_zoom_level = camera.translation[2]
	print(ship.name)

func _process(delta):	
	if(ship!=null):
		self.translation = ship.translation
	var rX = _next_rotation.y * rotation_speed * delta /Engine.time_scale *-1
	var rY = _next_rotation.x * rotation_speed * delta /Engine.time_scale *-1
	self.setCameraRotation(rX,rY)
	_next_rotation = Vector2(0,0)

func _set_zoom_level(value: float) -> void:	
	_zoom_level = clamp(value, min_zoom, max_zoom)
	tween.interpolate_property(
		camera,
		"translation",
		camera.translation,
		Vector3(0,0,_zoom_level),
		zoom_duration,
		tween.TRANS_SINE,	
		tween.EASE_OUT	
	)
	tween.start()	

func getCameraRotation():
	var result = Vector2(tilt.rotation.x, self.rotation.y)
	return result

func setCameraRotation(x,y):
	self.rotate_y(y)	
	if(abs(tilt.rotation.x+x)<=1.4):		
		tilt.rotate_x(x)
	
func _input(event):	
	if event.is_action_pressed("zoom_in"):
		zoom_factor = _zoom_level * zoom_factor_factor
		zoom_factor = clamp(zoom_factor,1,max_zoom*0.2)
		_set_zoom_level(_zoom_level - zoom_factor)		
	if event.is_action_pressed("zoom_out"):
		zoom_factor = _zoom_level * zoom_factor_factor
		zoom_factor = clamp(zoom_factor,1,max_zoom*0.2)
		_set_zoom_level(_zoom_level + zoom_factor)			
	if  event is InputEventMouseMotion:		
		_rotate_camera(event as InputEventMouseMotion)

func _rotate_camera(event:InputEventMouseMotion):
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		_next_rotation = event.relative		

#func changeState(newState:STATE):
#	self.state = newState
#	match (state):
#		STATE.LANDED:
#			storedFreeRotation = Vector3

func save():
	var save_dict = {
		"nodePath" : "Player",
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),	
		"tilt.rotation.x": tilt.rotation.x,
		"rotation.y" :rotation.y,
		"_zoom_level" : _zoom_level
	}
	print(self.get_signal_connection_list("fuel_changed"))
	return save_dict

func load_save(dict):	
	tilt.rotation.x = dict["tilt.rotation.x"]
	rotation.y = dict["rotation.y"]
	camera.translation.z = dict["_zoom_level"]
