extends StaticEnemy

func _ready():
	super._ready()
	$KillSat.remove_from_group("persist")

func _process(delta):
	print(str(self.position))
	if($KillSat!=null):
		$Alarm.visible = $KillSat.hasTarget()
	#$KillSat.transform.origin = Vector3(0,0,0)
