extends Node3D

var isOn = false

var lifeTime1
var lifeTime2
var lifeTime3

func _ready():
	$Fire1.emitting = false
	$Fire2.emitting = false
	$smoke.emitting = false
	
	lifeTime1 = $Fire1.lifetime
	lifeTime2 = $Fire2.lifetime
	lifeTime3 = $smoke.lifetime
	$EngineSound.stop()	

func on(throttle=1):
	if(!isOn):	
		if(throttle<0.1):return
		$Fire1.emitting = true
		$Fire2.emitting = true
		$smoke.emitting = true
		
		$Fire1.lifetime = lifeTime1*throttle
		$Fire2.lifetime = lifeTime2*throttle
		$smoke.lifetime = lifeTime3*throttle	

		$EngineSound.play()
		isOn = true

func off():
	if(isOn):
		$Fire1.emitting = false
		$Fire2.emitting = false
		$smoke.emitting = false
		
		$Fire1.lifetime = lifeTime1
		$Fire2.lifetime = lifeTime2
		$smoke.lifetime = lifeTime3	

		$EngineSound.stop()
		isOn = false

