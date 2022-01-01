extends Node
class_name AI

onready var ship:Ship = get_parent().get_child(0)
onready var bulletSpeed = ship.mounts[0].get_weapon_speed()
var markerPosition = Vector3(0,0,0)

func _process(delta):
	if(ship.hasTarget()):
		self._attackTarget(delta)		
		pass

func _attackTarget(delta):
	var position = get_parent().global_transform.origin
	var target_position =  ship.target.global_transform.origin	

	var rel_target_vel = ship.target.linear_velocity -  get_parent().linear_velocity
	if(rel_target_vel.length()>bulletSpeed):return #backup for NAN bug
	var timeToImpact = predict_t(target_position,rel_target_vel,bulletSpeed) #distance/bulletSpeed
	
	timeToImpact = clamp(timeToImpact,0.1,timeToImpact)
	
	var predicted_target_pos = target_position
	
	var targetMotion = timeToImpact*(ship.target.linear_velocity - get_parent().linear_velocity)
	predicted_target_pos += targetMotion

	
	var ship_g_displacement = (ship.target.last_g_force/ship.target.mass)*timeToImpact 
	predicted_target_pos += ship_g_displacement
	
	turn_ship_to(predicted_target_pos,delta)
	
	
	ship.linear_velocity = get_parent().linear_velocity	
	
	$"../Marker/PredictionMarker".global_transform.origin = markerPosition
	
	var fired = ship.fire()
	if(fired) : 
		markerPosition = predicted_target_pos + get_parent().linear_velocity
		print("sat p:" + str(position))
		print("sat v" + str(get_parent().linear_velocity))
		print("target p" + str(target_position))
		print("target v" + str(ship.target.linear_velocity))
		print(timeToImpact)
		print("")

func turn_ship_to(pos,  delta):
	var ownTransform= get_parent().global_transform
	var look_transform = ownTransform.looking_at(pos,Vector3(0,1,0))
	var angle = look_transform.basis.get_euler().y	
	print(angle)
	var angleD = angle - get_parent().rotation.y
	
	var turnAngle = clamp(angleD,ship.turn_rate*-1*delta/ship.mass,ship.turn_rate*delta/ship.mass)
	
	get_parent().rotate_y(turnAngle)	
	#get_parent().global_transform = look_transform

func predict_t(target_p:Vector3,target_v:Vector3,missile_v:float):
	var position = get_parent().global_transform.origin
	var rel_target_p = target_p - position
	
	var p1 = rel_target_p.x
	var p2 = rel_target_p.z
	var v1 = target_v.x
	var v2 = target_v.z
	var v3 = missile_v
	var t = 1
	
	if((v1*v1 + v2*v2 - v3*v3)!=0):	
		t = (-2*p1*v1 - 2*p2*v2 - sqrt(pow(-2*p1*v1 - 2*p2*v2,2) - 4*(-pow(p1,2) - p2*p2)*(-pow(v1,2) - v2*v2 + v3*v3)))/(2*(v1*v1 + v2*v2 - v3*v3))
	return t

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
