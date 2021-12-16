tool
extends Sprite3D





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Viewport/Label.text = get_parent().name


func _process(delta):
	$Viewport.size = $Viewport/Label.rect_size
