extends Node3D

enum SHIPTYPES{
	TENDER = 0,
	TENDER_S = 1,
	ROCKET_S = 2,
	ROCKET = 3,
	SKYCRANE = 4,
	SKYCRANE_S = 5,
	KILLSAT = 6,
	NONE = 999
}

@export 
var type : SHIPTYPES

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
