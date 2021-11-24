extends Node

export(NodePath) var slot_parent_path
onready var slot_parent:Node
var slots = []

var destinationMap={}

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
signal container_added(container)
signal container_removed(container)

func _ready():
	slot_parent = self.get_node_or_null(slot_parent_path)
	if slot_parent == null: slot_parent=self
	for c in slot_parent.get_children():
		if c is Position3D:
			slots.append(c)

func addContainter(container:MissionContainer, i : int):
	var slot = slots[i] as Position3D
	assert(slot.get_child_count()==0)
	slot.add_child(container)	
	container.translation = Vector3(0,0,0)
	container.connect("clicked",self,"_on_container_clicked")
	container.loaded = true	
	stock[container.cargo] = stock[container.cargo]+1
	_addToDestinationMap(container)	
	emit_signal("container_added",container)

func _addToDestinationMap(container:MissionContainer):
	var dest = container.destination.name
	if(!destinationMap.has(dest)||destinationMap[dest]==[]):
		destinationMap[dest] = [container]
	else:
		destinationMap[dest].append(container)		
	print(destinationMap)

func _removeFromDestinationMap(container:MissionContainer):
	var dest = container.destination.name
	var mapList = destinationMap[dest]
	mapList.erase(container)
	
func getContainer(i : int) -> MissionContainer:
	var slot = slots[i] as Position3D
	assert(slot.get_child_count()==1)	
	return slot.get_child(0)

func getAllContainter():
	var result = []
	for i in slots.size():
		var slot = slots[i]
		if(slot.get_child_count() != 0):
			result.append(slot.get_child(0))
	return result 
	
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
			_removeFromDestinationMap(container)
			emit_signal("container_removed",container)
			return true
	return false

func _on_container_clicked(container:MissionContainer):
	emit_signal("container_clicked",container)
