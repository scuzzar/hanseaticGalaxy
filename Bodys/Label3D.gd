extends Label

func _process(delta):
	var pos = get_parent().global_transform.origin
	if(get_viewport().get_camera_3d().is_position_behind(pos) or Globals.show_names!=true):
		self.hide()
	else:
		self.show()
		self.set_position(get_viewport().get_camera().unproject_position(pos))	
