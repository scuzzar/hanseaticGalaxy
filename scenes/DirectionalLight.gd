extends DirectionalLight

onready var ship = $"../Ship"
onready var sun = $"../Sun"

var up = Vector3(0,1,0)

func _process(delta):
	var t = ship.translation
	#self.rotate_y(delta)
	#print(self.rotation_degrees)
