extends Control

var warft:Port
var ShipForSale = []
var currentIndex = 0

signal shipOrderd(ship)

func setWarft(warft:Port):
	self.warft = warft
	self.ShipForSale = warft.getShipsForSale()
	self.update()
	
func update():
	$ShipInfo.setShip(ShipForSale[currentIndex])

func _on_next_pressed():
	if(!ShipForSale.empty()):
		currentIndex = (currentIndex + 1) % ShipForSale.size()
		update()

func _on_last_pressed():
	if(!ShipForSale.empty()):
		currentIndex = (currentIndex - 1)% ShipForSale.size()
		update()

func _on_Buy_pressed():
	if(!ShipForSale.empty()):
		self.emit_signal("shipOrderd",ShipForSale[currentIndex])
		currentIndex = 0
		setWarft(warft)
		if(!ShipForSale.empty()):
			self.update()
		else:
			self.hide()
