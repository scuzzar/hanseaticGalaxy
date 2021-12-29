extends Node
class_name AI

onready var ship:Ship = get_parent().get_child(0)

var turnAngle


func _physics_process(delta):
	if(ship.hasTarget()):
		self._attackTarget(delta)

func _attackTarget(delta):
	var position = get_parent().global_transform.origin
	var target_position =  ship.target.global_transform.origin
	var targetVector: Vector3 = target_position - position
	var currentHeading:Vector3 = get_parent().global_transform.basis.x
	var angle = currentHeading.angle_to(targetVector)	
	
	if(angle>PI):
		angle = 2*PI - angle
	
	turnAngle = clamp(angle,ship.turn_rate*-1,ship.turn_rate)
	
	get_parent().rotate_y(turnAngle*delta)
	
	ship.linear_velocity = get_parent().linear_velocity	
	ship.fire()

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
