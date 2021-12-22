extends Mission

class_name DeliveryMission

var destination :Spatial
var origin :Spatial
var cargoContainer = []
export(CargoContainer.CARGO) var cargo
const MissionContainerScene = preload("res://Cargo/CargoContainer.scn")

func _init():
	self.add_to_group("persist")

func _createContainer(amount):
	for i in amount:
		var c = MissionContainerScene.instance()
		c._set_cargo(cargo)		
		self.cargoContainer.append(c)

func _to_string()->String:
	if(destination!=null):
	#var text = "Destination: " + destination.name + " (" + str(self.reward) +"c) " + str(round(getDistance())) + "km"
		return  self.getCargoName() + " > " + destination.name + " C:" + str(self.reward) +" MASS:" + str(self.getMass()) #+ " D:" + str(getDistance()) 
	else:
		return "nullDestination"
		
		
func getDistance()->float:
	if(origin==null or destination==null): return 0.0	
	return origin.global_transform.origin.distance_to(destination.global_transform.origin) 


func getPrice():
	return cargoContainer[0].getPrice()
	
func getCargoName()-> String:
	return cargoContainer[0].getCargoName()


func getMass()->float:
	return cargoContainer[0].getMass()*getContainerCount()

func getContainerCount()->int:
	return cargoContainer.size()

func save():	
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"destination" : destination.get_path(),
		"origin" : origin.get_path(),
		"reward" : reward,
		"accepted" : accepted,
		"amount" : self.getContainerCount(),
		"cargo" : cargo
	}	
	return save_dict

func load_save(dict):
	reward = dict["reward"]
	destination = get_node(dict["destination"])
	origin = get_node(dict["origin"])
	cargo = CargoContainer.CARGO.values()[dict["cargo"]]
	self._createContainer(dict["amount"])
	accepted = dict["accepted"]
	
	#Has to be removed, because origin.add_all_Container(cargoContainer) will also add it
	self.get_parent().remove_child(self)
	var groups = self.get_groups()
	if(accepted):
		Player.ship.load_all_container(cargoContainer)
		Player.accepted_delivery_Missions.append(self)		
		Player.ship.add_child(self)
		pass
	else:
		origin.delivery_Missions.append(self)
		origin.remove_all_container(cargoContainer)
		origin.add_all_Container(cargoContainer)
		origin.add_child(self)
	pass
