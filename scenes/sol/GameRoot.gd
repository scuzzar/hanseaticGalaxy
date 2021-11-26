extends Spatial

var endScreen = preload("res://scenes/GameEnded/EndGameScreen.tscn")
#var loader : ResourceInteractiveLoader
onready var ship = $Ship

export var MaxtimeWarpFactor = 200

func _ready():
	$HUD.ship = ship
	$HUD/InventoryWindow.setShip(ship)
	$HUD/CargoBay.ship = ship

func _process(delta):
	if Input.is_action_pressed("endGame"):	
		print("you ended the game!")	
		call_deferred("_loadScore")		
		
	if Input.is_action_pressed("time_delay"):	
		var factor = clamp(1 / ship.last_g_force.length()*ship.mass,0.001,0.001)		
		call_deferred("setTimeScale",factor)
	if Input.is_action_pressed("time_warp"):		
		var factor = clamp(1 / ship.last_g_force.length()*ship.mass,5,MaxtimeWarpFactor)		
		call_deferred("setTimeScale",factor)
	
	if Input.is_action_pressed("cheat_fuel"):
		Player.pay(ship.get_refule_costs()*2)
		ship.set_fuel(ship.fuel_cap)	
		
	if(Player.engine_fuel_left<= 0):
		call_deferred("_loadScore")		

func _loadScore():
	var result = get_tree().change_scene_to(endScreen)
	if(result==OK):	
		print("Game over")
	else:
		print("faild to load Scene!")
		
func setTimeScale(factor):
	Engine.time_scale =  factor



func _on_Ship_strongest_body_changed(old_body, new_body):
	if(new_body.name == "Sun"):
		$Simulator.on = true
	else:
		$Simulator.on = false
