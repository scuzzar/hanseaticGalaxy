extends Mission

class_name DeliveryMission

var destination :Spatial
var origin :Spatial
var cargo = []

func _init(origin,destination):
	self.origin = origin
	self.destination = destination

func _to_string()->String:
	if(destination!=null):
	#var text = "Destination: " + destination.name + " (" + str(self.reward) +"c) " + str(round(getDistance())) + "km"
		return  cargo.getCargoName() + " > " + destination.name + " C:" + str(self.reward) +" MASS:" + str(cargo.getMass()) #+ " D:" + str(getDistance()) 
	else:
		return "nullDestination"
		
		
func getDistance()->float:
	if(origin==null or destination==null): return 0.0	
	return origin.global_transform.origin.distance_to(destination.global_transform.origin) 


func getPrice():
	return cargo[0].getPrice()
	
func getCargoName()-> String:
	return cargo[0].getCargoName()


func getMass()->float:
	return cargo[0].getMass()

func getContainerCount()->int:
	return cargo.size()

func save():	
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"destination" : destination.get_path(),
		"origin" : origin.get_path(),
		"reward" : reward			
	}
	return save_dict

func load_save(dict):
	reward = dict["reward"]
	destination = get_node(dict["destination"])
	origin = get_node(dict["origin"])
	pass
