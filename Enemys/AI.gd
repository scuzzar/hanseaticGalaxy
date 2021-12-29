extends Node
class_name AI

onready var ship:Ship = get_parent().get_child(0)
var bulletSpeed = 50

func _physics_process(delta):
	if(ship.hasTarget()):
		self._attackTarget(delta)

func _attackTarget(delta):
	var position = get_parent().global_transform.origin
	var target_position =  ship.target.global_transform.origin	
	
	var distance = position.distance_to(target_position)
	var timeToImpact = distance/bulletSpeed
	var motionOffset = timeToImpact*(ship.target.linear_velocity-get_parent().linear_velocity)
	
	var ship_g_displacement = (ship.target.last_g_force/ship.target.mass)*timeToImpact 

	motionOffset += ship_g_displacement
	
	var predicted_target_pos = target_position + (motionOffset)
	
	var look_transform = get_parent().global_transform.looking_at(predicted_target_pos,Vector3(0,1,0))
	var angle = look_transform.basis.get_euler().y	
	var angleD = angle - get_parent().rotation.y
	
	var turnAngle = clamp(angleD,ship.turn_rate*-1*delta/ship.mass,ship.turn_rate*delta/ship.mass)
	
	get_parent().rotate_y(turnAngle)	
	
	ship.linear_velocity = get_parent().linear_velocity	
	
	var fired = ship.fire()
	if(fired) : 
		print("sat p:" + str(position))
		print("sat v" + str(get_parent().linear_velocity))
		print("target p" + str(target_position))
		print("target v" + str(ship.target.linear_velocity))
		print("")

func _on_Attention_body_entered(body):
	if(_isEnemyShip(body)):
		ship.target = body

func _on_Attention_body_exited(body):
	if(ship.target==body):
		ship.target = null

func _isEnemyShip(body):
	if(body is Ship):
		var tShip =body as Ship
		if(tShip.team != ship.team and tShip.team != ENUMS.TEAM.NEUTRAL):
			return true
	return false
