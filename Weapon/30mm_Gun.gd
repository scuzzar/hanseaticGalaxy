extends Spatial

var bulletScene = preload("res://Weapon/Bullet.tscn")
export var scatter = 0.1
export var cooldown = 0.05
export var nozzel_speed = 50
export var damage = 10
var ran = RandomNumberGenerator.new()
onready var ship:Ship = get_parent()

func fire():
	if($Timer.time_left==0):	
		$Timer.start(cooldown)
		var bullet = bulletScene.instance()		
		bullet.speed = nozzel_speed
		bullet.damage = damage
		bullet.transform = $BulletPoint.global_transform
		get_node("/root/Sol").add_child(bullet)
		var offset_velocity:Vector3  = get_parent().linear_velocity	
		bullet.velocity += offset_velocity
		var noise = Vector3(ran.randfn(0,scatter),ran.randfn(0,scatter),ran.randfn(0,scatter))
		bullet.velocity += noise
		bullet.team = ship.team


