extends Spatial

func _ready():
	trust_forward_on()

func trust_forward_on():
	$particel.on()

func _trust_forward_off():
	$particel.off()

func all_trust_off():
	_trust_forward_off()
	_trust_backward_off()
	_trust_lateral_right_off()
	_trust_lateral_left_off()	

func trust_backward_on():
	pass
	
func _trust_backward_off():
	pass

func trust_lateral_right_on():
	pass
	
func _trust_lateral_right_off():
	pass
	
func trust_lateral_left_on():
	pass
	
func _trust_lateral_left_off():
	pass

