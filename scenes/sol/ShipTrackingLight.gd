extends DirectionalLight3D

@onready var target =  $"../../PlayerShip"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target =  $"../../PlayerShip"
	self.look_at(target.position)
	pass
