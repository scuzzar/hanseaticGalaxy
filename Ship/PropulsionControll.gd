extends Spatial

var mainDrive = []
var leftTruster = []
var rightTruster = []
var forwardTruster = []
var backTruster= []

func _ready():
	mainDrive = $mainDrive.get_children()
	leftTruster = $leftTruster.get_children()
	rightTruster = $rightTruster.get_children()
	forwardTruster = $forwardTruster.get_children()
	backTruster= $backTruster.get_children()

func trust_Vector(v:Vector2, throttle:float = 1):
	if(throttle<=0.1):
		all_trust_off()
		return
		
	if(v.x>0):
		trust_lateral_forward_on(abs(v.x)) 
	else:
		_trust_lateral_forward_off()
	
	if(v.x<0):
		trust_backward_on(abs(v.x))
	else:
		_trust_backward_off()
		
	if(v.y<0):
		trust_lateral_left_on(abs(v.y)) 
	else:
		_trust_lateral_left_off()
		
	if(v.y>0):
		trust_lateral_right_on(abs(v.y))
	else:
		_trust_lateral_right_off()	
	pass

func drive_on(throttle=1):
	for d in mainDrive:	d.on(throttle)

func drive_off():
	for d in mainDrive:	d.off()

func all_trust_off():
	_trust_backward_off()
	_trust_lateral_forward_off()
	_trust_lateral_right_off()
	_trust_lateral_left_off()	

func trust_backward_on(throttle=1):
	for d in backTruster:	d.on(throttle)
	
func _trust_backward_off():
	for d in backTruster:	d.off()

func trust_lateral_forward_on(throttle=1):
	for d in forwardTruster:	d.on(throttle)
	
func _trust_lateral_forward_off():
	for d in forwardTruster: d.off()

func trust_lateral_right_on(throttle=1):
	for d in leftTruster:d.on(throttle)
	
func _trust_lateral_right_off():
	for d in leftTruster:d.off()
	
func trust_lateral_left_on(throttle=1):
	for d in rightTruster:	d.on(throttle)
	
func _trust_lateral_left_off():
	for d in rightTruster: d.off()

