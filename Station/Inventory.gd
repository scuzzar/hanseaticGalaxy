extends Node

onready var slots = self.get_children()

signal container_clicked(container)

func _ready():
	_remove_dummys()
	
func _remove_dummys():
	for slot in slots:
		if(slot.get_child_count()==1 and slot.get_child(0).name =="dummy"):
			self.removeContainer(slot.get_child(0))

func addContainter(container:MissionContainer, i : int):
	var slot = slots[i] as Position3D
	assert(slot.get_child_count()==0)
	slot.add_child(container)	
	container.translation = Vector3(0,0,0)
	container.connect("clicked",self,"_on_container_clicked")
	container.loaded = true	

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

func hadSpace() -> bool:
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


func removeContainer(container:MissionContainer) -> bool :	
	for slot in slots:
		if(slot.get_child_count() == 1 and slot.get_child(0)==container):
			slot.remove_child(container)			
			container.disconnect("clicked",self,"_on_container_clicked")
			container.loaded = false	
			return true
	return false

func _on_container_clicked(container:MissionContainer):
	emit_signal("container_clicked",container)
