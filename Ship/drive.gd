extends Spatial

var on = false

func _ready():
	$Fire1.emitting = false
	$Fire2.emitting = false
	$EngineSound.stop()

func on():
	if(!on):
		$Fire1.emitting = true
		$Fire2.emitting = true
		$OmniLight.start()
		$EngineSound.play()
		on = true

func off():
	if(on):
		$Fire1.emitting = false
		$Fire2.emitting = false
		$OmniLight.stop()
		$EngineSound.stop()
		on = false

