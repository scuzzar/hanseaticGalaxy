extends Satellite

class_name StaticEnemy

@export
var bounty = 0

func _on_Ship_destroyed():
	self.queue_free()
	$AI.set_process(false)
	$Attention.monitoring = false
	Player.reward(bounty)

func _on_mission_abouted():
	$MissionEndedTimer.start()

func _on_MissionEndedTimer_timeout():
	self.queue_free()
	$AI.set_process(false)
	$Attention.monitoring = false
