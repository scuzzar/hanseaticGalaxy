extends Satellite

func _on_KillSat_destryed():
	self.queue_free()
	$AI.set_process(false)
	$Attention.monitoring = false

