extends AudioStreamPlayer3D

@onready var tween : Tween

@export var fadeIn_duration:float = 1
@export var fadeOut_duration:float = 1

var _db_target : float

func _ready():
	tween = get_tree().create_tween()	
	_db_target = self.volume_db
	self.volume_db = -80

var transition_type = 1 # TRANS_SINE

func play(from_position:float = 0.0):	
	super.play(from_position)
	tween.finished.disconnect(_on_TweenOut_tween_completed)
	tween = get_tree().create_tween()	
	tween.tween_property(self, "volume_db", _db_target, fadeIn_duration)

func stop():	
	tween = get_tree().create_tween()	
	tween.tween_property(self, "volume_db", -100, fadeOut_duration)
	tween.finished.connect(_on_TweenOut_tween_completed)

func _on_TweenOut_tween_completed():
	super.stop()
