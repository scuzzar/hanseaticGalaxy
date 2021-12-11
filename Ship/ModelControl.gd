extends Spatial

func _ready():
	trust_forward_on()

func trust_forward_on():
	$particel.on()

func trust_forward_off():
	$particel.off()

