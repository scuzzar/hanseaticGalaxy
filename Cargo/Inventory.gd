extends Node

export(NodePath) var slot_parent_path
onready var slot_parent:Node
var slots = []

var stock ={
	TYP.CARGO.METALS:0,
	TYP.CARGO.FOOD:0,
	TYP.CARGO.MACHINES:0,
	TYP.CARGO.ELECTRONICS:0,
	TYP.CARGO.CONSUMERS:0,
	TYP.CARGO.RARE_METALS:0,
	TYP.CARGO.LUXUS:0,
	TYP.CARGO.ICE:0,
	TYP.CARGO.WATER:0,
	TYP.CARGO.OXYGEN:0,
	TYP.CARGO.HABITATION:0,
	TYP.CARGO.INFRASTRUCTURE:0,
	TYP.CARGO.STEEL:0,
	TYP.CARGO.ENERGY:0,
	TYP.CARGO.DEUTERIUM:0
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

func addContainter(container:CargoContainer, i : int):
	var slot = slots[i] as Position3D
	assert(slot.get_child_count()==0)	
	slot.add_child(container)	
	#container.translation = Vector3(0,0,0)
	container.connect("clicked",self,"_on_container_clicked")
	container.loaded = true	
	stock[container.cargo] = stock[container.cargo]+1
	
	emit_signal("container_added",container)

func addAllContainerOnFree(ContainerArray)->bool:
	if(freeSpace()>=ContainerArray.size()):
		for c in ContainerArray:
			addContainerOnFree(c)
		return true
	else:
		return false

func getContainer(i : int) -> CargoContainer:
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
	
func addContainerOnFree(container:CargoContainer) -> bool:
	for i in slots.size():
		var slot = slots[i]
		if(slot.get_child_count() == 0):
			self.addContainter(container,i)
			return true
	return false

func hasSpace() -> bool:
	return freeSpace()!=0

func freeSpace() -> int:
	var result = 0
	for i in slots.size():
		var slot = slots[i]
		if(slot.get_child_count() == 0):			
			result +=1
	return result

func hasContainer(container:CargoContainer) -> bool:
	for slot in slots:
		var hasChild = slot.get_child_count() == 1
		if(hasChild):
			var child = slot.get_child(0)
			var Container_is_child = child==container
			if( Container_is_child ):			
				return true
	return false

func stock(cargo)->int:
	return stock[cargo]
	
func remove_all_container(ContainerArray) -> bool:
	var status = true
	for c in ContainerArray:
		status = status and self.removeContainer(c)
	return status

func removeContainer(container:CargoContainer) -> bool :	
	for slot in slots:
		if(slot.get_child_count() == 1 and slot.get_child(0)==container):
			slot.remove_child(container)			
			container.disconnect("clicked",self,"_on_container_clicked")
			container.loaded = false
			stock[container.cargo] = stock[container.cargo]-1			
			emit_signal("container_removed",container)
			return true
	return false

