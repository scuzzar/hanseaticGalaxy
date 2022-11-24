extends "res://Mission/Delivery/InventoryView.gd"

@onready var mass_value = $Footer/mass_value
@onready var max_mass_value = $Footer/max_mass_value



var refuel_cart_mass = 0

var port : Port
signal accepted(container)
signal cartUpdate(slots,mass,reward)

func _getMissions():	
	if(port!=null):
		return port.get_all_DeliveryMissions()
	else:
		return []

func setPort(target):
	self.port = target	
	self.update()
	var existingConnection = target.inventory.is_connected("container_added", self._Inventory_added_container)
	if(!existingConnection):	
		target.inventory.connect("container_added", self._Inventory_added_container)

func clearPort(target):
	self.port = null
	self.table.unselectAll()
	var existingConnection = target.inventory.is_connected("container_added", self._Inventory_added_container)
	if(existingConnection):
		target.inventory.disconnect("container_added", self._Inventory_added_container)

func update():
	if(port!=null and ship !=null):
		super.update()
		_on_ship_mass_change()

func _on_selection_update(mission:DeliveryMission,is_Checked):
	self._on_ship_mass_change()

func _on_ship_mass_change():
	max_mass_value.text  = str("%0.2f" % ship.getMaxStartMass())
	mass_value.text = str("%0.2f" % (ship.mass+table.SelectedMissionsMass + refuel_cart_mass))

func _on_visibility_changed():
	if(self.is_visible_in_tree()):
		update()

func _on_refuel_cart_change(amount):
	self.refuel_cart_mass = amount*Globals.get_fuel_mass()
	self._on_ship_mass_change()
