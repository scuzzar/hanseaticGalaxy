extends StaticEnemy

func _process(delta):
	$Alarm.visible = $KillSat.hasTarget()
		
