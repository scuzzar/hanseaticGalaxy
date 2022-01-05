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

func trust_Vector(v:Vector3):
	print(v)
	if(v.length()<=0.1):
		all_trust_off()
		return
		
	if(v.x>0):
		trust_lateral_forward_on() 
	else:
		_trust_lateral_forward_off()
	
	if(v.x<0):
		trust_backward_on()
	else:
		_trust_backward_off()
		
	if(v.z<0):
		trust_lateral_left_on() 
	else:
		_trust_lateral_left_off()
		
	if(v.z>0):
		trust_lateral_right_on()
	else:
		_trust_lateral_right_off()
	
	pass

func trust_forward_on():
	for d in mainDrive:	d.on()

func _trust_forward_off():
	for d in mainDrive:	d.off()

func all_trust_off():
	_trust_forward_off()
	_trust_backward_off()
	_trust_lateral_forward_off()
	_trust_lateral_right_off()
	_trust_lateral_left_off()	

func trust_backward_on():
	for d in backTruster:	d.on()
	
func _trust_backward_off():
	for d in backTruster:	d.off()

func trust_lateral_forward_on():
	for d in forwardTruster:	d.on()
	
func _trust_lateral_forward_off():
	for d in forwardTruster: d.off()

func trust_lateral_right_on():
	for d in leftTruster:d.on()
	
func _trust_lateral_right_off():
	for d in leftTruster:d.off()


	
	
func trust_lateral_left_on():
	for d in rightTruster:	d.on()
	
func _trust_lateral_left_off():
	for d in rightTruster: d.off()

