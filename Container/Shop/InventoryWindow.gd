extends Panel

var rawScene = preload("res://Container/Shop/raw.tscn")
onready var vBox = $"Container/VBoxContainer"


func _ready():
	add_raw("test","test","test","test")
	add_raw("test","test","test","test")
	add_raw("test","test","test","test")
	pass # Replace with function body.

func add_raw(good,destination,distance,reward):
	var newRaw = rawScene.instance()
	vBox.add_child(newRaw) # Add it as a child of this node.
	pass
