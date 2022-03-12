extends Node3D

enum TEST{
	test =1,
	no_test =2
}

@export
var testerv : TEST

# Called when the node enters the scene tree for the first time.
func _ready():
	TEST.value
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
