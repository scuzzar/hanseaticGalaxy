extends Spatial

func _ready():
	print("ready")
	trust_forward_on()

func trust_forward_on():
	$particel.on()
	$particel2.on()
	$particel3.on()
	$particel4.on()

func trust_forward_off():
	$particel.off()
	$particel2.off()
	$particel3.off()
	$particel4.off()
