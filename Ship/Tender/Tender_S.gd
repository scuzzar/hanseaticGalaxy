extends Ship

func _process(delta):
	if(playerControl):
		if Input.is_action_pressed("fire"):
			$"30mm".fire()
	pass
