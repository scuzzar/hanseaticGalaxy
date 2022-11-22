@tool
extends Tree

#var root

signal selectionChanged(mission,state)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#root = self.create_item()
	
	self.set_column_title(1, "Destination")
	self.set_column_title(2, "Good")
	self.set_column_title(3, "Mass")
	self.set_column_title(4, "Reward")
	self.set_column_title(5, "Min DV")
	
	self.set_hide_root(true)

func addContent(mission:DeliveryMission):
	
	var child1 = self.create_item()	
	
	# Checkbox ###
	child1.set_cell_mode(0,TreeItem.CELL_MODE_CHECK)	
	child1.set_editable(0,true)
	child1.set_selectable(0,false)
	# Link to Mission
	child1.set_metadata(0,mission)
	
	# Destination ####	
	var destinationText = str(mission.destination.name)
		
	# Pirate Level
	if((mission.destination as Port).getBody().securety_level==ENUMS.SECURETY.BELT):
		destinationText += "*"
	
	child1.set_text(1, destinationText)
	child1.set_text_alignment(1,HORIZONTAL_ALIGNMENT_CENTER)	
	child1.set_selectable(1,false)
	
	
	# Good Name ####
	child1.set_text(2, mission.getCargoName())
	child1.set_text_alignment(2,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_selectable(2,false)
	
	# Mass ####
	var massText		
	if(mission.getContainerCount()==1):
		massText = str(mission.getMass())
	else:
		massText = str(mission.getContainerCount())  + " x " + str(mission.getMass()/mission.getContainerCount()) 
	
	child1.set_text(3, massText)
	child1.set_text_alignment(3,HORIZONTAL_ALIGNMENT_CENTER)
	child1.set_selectable(3,false)
	
	# Reward ####
	child1.set_text(4, str(mission.reward))
	child1.set_text_alignment(4,HORIZONTAL_ALIGNMENT_CENTER)	
	child1.set_selectable(4,false)
	
	# MinDV ####	
	child1.set_text(5, str("%0.1f" %D_V_Estimator.mission_d_v(mission)))
	child1.set_text_alignment(5,HORIZONTAL_ALIGNMENT_CENTER)	 
	child1.set_selectable(5,false)

func _on_tree_item_edited():
	var item = self.get_edited()
	var item_col = self.get_edited_column()
	if(item_col == 0):		
		var mission = item.get_metadata(0)
		var state = item.is_checked(0)
		print(mission._to_string())
		emit_signal("selectionChanged",mission,state)	
	pass # Replace with function body.
