extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float) var speed = 10
export(int) var damage = 1
var velocity :  Vector3
var team = ENUMS.TEAM.NEUTRAL


func _ready():	
	var parent = get_parent()
	velocity = global_transform.basis.x *speed 	

func _physics_process(delta):	
	self.global_translate(velocity*delta)

func _on_Bullet_body_entered(body):
	if(body is Ship):
		var ship = body as Ship
		if (ship.team != team):
			self._ship_hit(body as Ship)
			self.queue_free()	
	else:
		self.queue_free()

func _ship_hit(ship:Ship):
	ship.takeDamege(damage)


func _on_Timer_timeout():
	self.queue_free()
