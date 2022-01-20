extends StaticEnemy

func _ready():
	$KillSat.remove_from_group("persist")

func _process(delta):
	if($KillSat!=null):
		$Alarm.visible = $KillSat.hasTarget()
	#$KillSat.transform.origin = Vector3(0,0,0)
