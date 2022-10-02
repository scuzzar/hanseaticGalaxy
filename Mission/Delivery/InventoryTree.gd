@tool
extends Tree

@export var button : Texture2D

var root

# Called when the node enters the scene tree for the first time.
func _ready():
	
	root = self.create_item()
	
	self.set_column_title(0, "Destination")
	self.set_column_title(1, "Good")
	self.set_column_title(2, "Mass")
	self.set_column_title(3, "Reward")
	self.set_column_title(4, "Min DV")
	
	self.set_hide_root(true)


func setContent(m:DeliveryMission):
	var child1 = self.create_item(root)
	child1.set_text(0, "Fu")
	child1.set_text_alignment(0,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_text(1, "Fu")
	child1.set_text_alignment(1,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_text(2, "Fu")
	child1.set_text_alignment(2,HORIZONTAL_ALIGNMENT_CENTER)
	child1.add_button(3,button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
