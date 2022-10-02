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
		_add_dummy_raw(self)


	

func _add_dummy_raw(meta):
	var child1 = self.create_item(root)	

	#child1.set_text_alignment(0,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_cell_mode(0,TreeItem.CELL_MODE_CHECK)	
	child1.set_editable(0,true)
	
	child1.set_text(1, "100")
	child1.set_text_alignment(1,HORIZONTAL_ALIGNMENT_CENTER)	
	child1.set_text(2, "15653")
	child1.set_text_alignment(2,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_text(3, "15653")
	child1.set_text_alignment(3,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_text(4, "Fuuuuu")
	child1.set_editable(4,true)
	child1.set_text_alignment(4,HORIZONTAL_ALIGNMENT_CENTER)
	
	child1.set_cell_mode(5,TreeItem.CELL_MODE_RANGE)
	child1.set_range_config(5,-500,500,10)
	child1.set_range(5,0)
	child1.set_text_alignment(5,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_editable(5,true)
	
		
	
	
	child1.set_metadata(0,meta)
	child1.set_selectable(0,false)
	


func _on_tree_item_selected():
	var item = self.get_selected()
	print(item)
	var s = item.is_checked(0)
	item.set_checked(0,not s)
	


func _on_tree_item_edited():
	var item = self.get_edited()
	var item_col = self.get_edited_column()
	if(item_col == 0):
		var meta = item.get_metadata(0)
		print(meta.get_edited())
	pass # Replace with function body.
