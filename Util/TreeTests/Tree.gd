@tool
extends Tree

@export var button : Texture2D

var root

# Called when the node enters the scene tree for the first time.
func _ready():
	
	root = self.create_item()
	
	self.set_column_title(1, "Destination")
	self.set_column_title(2, "Good")
	self.set_column_title(3, "Mass")
	self.set_column_title(4, "Reward")
	self.set_column_title(5, "Min DV")
	
	self.set_hide_root(true)
	
	for i in range(0,7):
		_add_dummy_raw()


	

func _add_dummy_raw():
	var child1 = self.create_item(root)	

	#child1.set_text_alignment(0,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_cell_mode(0,TreeItem.CELL_MODE_CHECK)	
	
	child1.set_text(1, "100")
	child1.set_text_alignment(1,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_text(2, "15653")
	child1.set_text_alignment(2,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_text(3, "15653")
	child1.set_text_alignment(3,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_text(4, "15653")
	child1.set_text_alignment(4,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_text(5, "15653")
	child1.set_text_alignment(5,HORIZONTAL_ALIGNMENT_CENTER)
	child1
	



