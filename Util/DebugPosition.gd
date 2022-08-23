extends Node3D

@export 
var intervall = 0.5
var timer = 0

@export
var global = true


# Called when the node enters the scene tree for the first time.
func _ready():	
	_printPostion()
	print("after Ready\n")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if(timer>intervall):
		timer = 0
		_printPostion()
	pass

func _printPostion():
	var pPos = Vector3(0,0,0)
	if(global):
		pPos = self.get_parent().global_position
	else:
		pPos = self.get_parent().position
		
	print(str(get_parent().name) + " at " + str(pPos))
