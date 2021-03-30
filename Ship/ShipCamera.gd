extends Spatial

onready var ship:Ship = get_node("../Ship")
onready var tilt:Spatial = $TiltAxis
onready var camera:Camera = $TiltAxis/Camera

export var min_zoom := 0.5
export var max_zoom := 10000
export var zoom_factor := 1
export var zoom_factor_factor := 0.2
export var zoom_duration := 0.2

var _zoom_level := 1.0 setget _set_zoom_level

onready var tween: Tween = $ZoomTween

func _ready():
	_zoom_level = camera.translation[2]
	print(ship.name)

func _process(delta):	
	self.translation = ship.translation
	
	#self.look_at(ship.last_g_force-self.translation,Vector3(0,1,0))

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

func _input(event):	
	if event.is_action_pressed("zoom_in"):
		zoom_factor = _zoom_level * zoom_factor_factor
		zoom_factor = clamp(zoom_factor,1,max_zoom*0.2)
		_set_zoom_level(_zoom_level - zoom_factor)		
	if event.is_action_pressed("zoom_out"):
		zoom_factor = _zoom_level * zoom_factor_factor
		zoom_factor = clamp(zoom_factor,1,max_zoom*0.2)
		_set_zoom_level(_zoom_level + zoom_factor)		
	
	print(zoom_factor)
	print(_zoom_level)

