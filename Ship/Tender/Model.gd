extends "res://Ship/ModelControl.gd"


func trust_forward_on():
	$particel.on()
	$particel2.on()
	$particel3.on()
	$particel4.on()
	
func _trust_forward_off():
	$particel.off()
	$particel2.off()
	$particel3.off()
	$particel4.off()
	
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
