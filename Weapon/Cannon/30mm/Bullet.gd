extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed :float = 10
var damage : int= 1
var velocity :  Vector3
var team = ENUMS.TEAM.NEUTRAL
var max_distance :float = 10

func _ready():	
	var parent = get_parent()
	velocity = global_transform.basis.x *speed 		
	$LifeTime.wait_time = max_distance/speed
	if(max_distance/speed<=0):
		print("Aaa")
	$LifeTime.start()

func _physics_process(delta):	
	self.global_translate(velocity*delta)

func _on_Bullet_body_entered(body):
	if(body is Ship):
		var ship = body as Ship
		if (ship.team != team):
			self._ship_hit(body as Ship)			
	else:
		$Hit.play()
		$LifeTime.stop()

func _ship_hit(ship:Ship):
	ship.takeDamege(damage)
	$Hit.play()
	$LifeTime.stop()

func _on_Timer_timeout():
	self.queue_free()

func _on_Hit_finished():
	self.queue_free()
