extends AudioStreamPlayer3D

@onready
var tweenOut = get_tree().create_tween()

@onready var tween : Tween

@export var fadeIn_duration:float = 1
@export var fadeOut_duration:float = 1

func _ready():
	tween = get_tree().create_tween()	

var transition_type = 1 # TRANS_SINE

func play(from_position:float = 0.0):	
	super.play(from_position)
	tween = get_tree().create_tween()	
	tween.tween_property(self, "unit_db", 0, fadeIn_duration)

func stop():	
	tween = get_tree().create_tween()	
	tween.tween_property(self, "unit_db", -100, fadeOut_duration)
	tween.finished.connect(_on_TweenOut_tween_completed)

func _on_TweenOut_tween_completed():
	super.stop()
