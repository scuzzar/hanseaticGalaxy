extends CSGTorus3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var t = get_tree().create_tween()
	t.tween_property(self,"outer_radius",100,40).start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
