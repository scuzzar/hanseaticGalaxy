extends Spatial

export(float) var lightIntensity = 7

func _ready():
	self.off()

func on():
	$Fire1.emitting = true
	$Fire2.emitting = true
	$OmniLight.light_energy = lightIntensity

func off():
	$Fire1.emitting = false
	$Fire2.emitting = false
	$OmniLight.light_energy = 0
