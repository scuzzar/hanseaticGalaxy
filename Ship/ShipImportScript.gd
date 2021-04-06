tool
extends EditorScenePostImport

func post_import(ship):
	var slotNr = 1
	ship = ship as Spatial
	for c in ship.get_children():
		if c.name.begins_with("slot"):
			var new_slot = Position3D.new()			
			new_slot.name = "slot"+str(slotNr)
			slotNr += 1
			ship.add_child(new_slot)
			new_slot.set_owner(ship)
			#slots.append(new_slot)
			new_slot.translation = c.translation
			new_slot.rotation = c.rotation
			ship.remove_child(c)			
	return ship 

