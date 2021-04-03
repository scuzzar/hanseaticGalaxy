extends Node

onready var slots = self.get_children()

var stock ={
	MissionContainer.CARGO.METALS:0,
	MissionContainer.CARGO.FOOD:0,
	MissionContainer.CARGO.MACHINES:0,
	MissionContainer.CARGO.ELECTRONICS:0,
	MissionContainer.CARGO.CONSUMERS:0,
	MissionContainer.CARGO.RARE_METALS:0,
	MissionContainer.CARGO.LUXUS:0
}

signal container_clicked(container)

func _ready():
	_remove_dummys()
	
func _remove_dummys():
	for slot in slots:
		for child in slot.get_children():
			if(child.name=="dummy"):
				self.removeContainer(slot.get_child(0))

func addContainter(container:MissionContainer, i : int):
	var slot = slots[i] as Position3D
	assert(slot.get_child_count()==0)
	slot.add_child(container)	
	container.translation = Vector3(0,0,0)
	container.connect("clicked",self,"_on_container_clicked")
	container.loaded = true	
	stock[container.cargo] = stock[container.cargo]+1

func getContainer(i : int) -> MissionContainer:
	var slot = slots[i] as Position3D
	assert(slot.get_child_count()==1)	
	return slot.get_child(0)

func addContainerOnFree(container:MissionContainer) -> bool:
	for i in slots.size():
		var slot = slots[i]
		if(slot.get_child_count() == 0):
			self.addContainter(container,i)
			return true
	return false

func hasSpace() -> bool:
	for i in slots.size():
		var slot = slots[i]
		if(slot.get_child_count() == 0):			
			return true
	return false

func hasContainer(container:MissionContainer) -> bool:
	for slot in slots:
		if(slot.get_child_count() == 1 and slot.get_child(0)==container):			
			return true
	return false

func stock(cargo)->int:
	#var stock = 0
	#for slot in slots:
	#	if(slot.get_child_count() == 1 and slot.get_child(0).cargo == cargo):
	#		stock += 1
	return stock[cargo]
	
func removeContainer(container:MissionContainer) -> bool :	
	for slot in slots:
		if(slot.get_child_count() == 1 and slot.get_child(0)==container):
			slot.remove_child(container)			
			container.disconnect("clicked",self,"_on_container_clicked")
			container.loaded = false
			stock[container.cargo] = stock[container.cargo]-1
			return true
	return false

func _on_container_clicked(container:MissionContainer):
	emit_signal("container_clicked",container)
