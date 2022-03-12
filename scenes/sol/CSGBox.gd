extends CSGBox

@onready var t

func _process(delta):
	t = get_parent().angular_speed
	self.rotate_y(t*delta*3)
