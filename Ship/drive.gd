extends Spatial

func _ready():
	self.off()

func on():
	$Fire1.emitting = true
	$Fire2.emitting = true
	$OmniLight.light_energy = 7

func off():
	$Fire1.emitting = false
	$Fire2.emitting = false
	$OmniLight.light_energy = 0
