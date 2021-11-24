extends Tree

func _ready():
	var root = self.create_item()
	self.set_hide_root(true)
	var child1 = self.create_item(root)
	child1.set_text(0,"Earth")
	
	var child2 = self.create_item(root)
	var subchild1 = self.create_item(child1)
	subchild1.set_text(0, "ORE")
	subchild1.set_text(1, "14572c")
	#subchild1.set_button(3,1,NIL)
