extends Panel

var ship:Ship

func setShip(ship:Ship):
	self.ship = ship
	$Grid/name.text 		= ship.dispay_name
	$Grid/mass.text 		= str("%0.f" % ship.mass)
	$Grid/trust.text 		= str("%0.f" % ship.trust)
	$Grid/turnRate .text 	= str("%0.f" % ship.turn_rate)
	$Grid/slots.text 	= str("%0.f" % ship.getCargoSlotCount())	
	$Grid/price.text 	= str("%0.f" % ship.price)
