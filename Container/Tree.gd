extends Tree


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Texture) var buyButton;

# Called when the node enters the scene tree for the first time.
func _ready():
	var tree = self
	var root = tree.create_item()
	tree.set_hide_root(true)
	var child1 = tree.create_item(root)
	
	child1.set_text(0,"ERZ")
	child1.set_text(1,"50")
	child1.set_text(2,"Apollo")
	child1.add_button(3,buyButton)
	
	child1 = tree.create_item(root)
	child1.set_text(0,"ERZ")
	child1.set_text(1,"50")
	child1.set_text(2,"Apollo")
	child1.add_button(3,buyButton)
	
	child1 = tree.create_item(root)
	child1.set_text(0,"ERZ")
	child1.set_text(1,"50")
	child1.set_text(2,"Apollo")
	child1.add_button(3,buyButton)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
