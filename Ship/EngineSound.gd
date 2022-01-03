extends AudioStreamPlayer3D

onready var tweenOut = $TweenOut
onready var tweenIn = $TweenIn

export var fadeIn_duration:float = 1
export var fadeOut_duration:float = 1

var transition_type = 1 # TRANS_SINE


func stop():
	fade_out()

func play(from_position:float = 0.0):	
	.play(from_position)
	fade_in()

func fade_in():
	tweenOut.stop_all()
	tweenIn.interpolate_property(self, "unit_db", self.unit_db, 0, fadeIn_duration, transition_type, Tween.EASE_IN, 0)
	tweenIn.start()


func fade_out():
	tweenOut.interpolate_property(self, "unit_db", self.unit_db, -100, fadeOut_duration, transition_type, Tween.EASE_IN, 0)
	tweenOut.start()

func _on_TweenOut_tween_completed(object, key):
	self.stop()
