# Shift all nodes so the parent node always stays close to the center.
extends Node

@export var MAX_DISTANCE = 2000.0
@export var activ = true
@export var logging = false

var originShift = Vector3(0,0,0)

@export var world_node_path : NodePath
@onready var world_node: Node3D = get_node_or_null(world_node_path)

@onready var parent = $"../PlayerShip"

signal shifted()

func _ready():
	if !world_node:
		world_node = get_node("../..")

func _process(delta):
	if(!is_instance_valid(parent)):return
	if activ and parent.global_transform.origin.length() > MAX_DISTANCE:
		call_deferred("shift_origin")

func shift_origin():
	var offset: Vector3 = parent.global_transform.origin
	for child in world_node.get_children():
		if child is Node3D:
			if(logging):
				print(str(child.name) + " shifterd")
				print("from: /t" + str(child.global_transform.origin))	
			child.global_translate(-offset)
			if(logging):		
				print("to: /t" + str(child.global_transform.origin))
	originShift = offset
	emit_signal("shifted")
	if logging:
		print("shifted " + str(offset))
