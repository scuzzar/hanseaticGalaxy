extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var rotation_speed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	rotate(Vector3(0,1,0),rotation_speed*delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
