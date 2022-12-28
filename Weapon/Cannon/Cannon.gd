@tool
extends Node3D



var type = ENUMS.WEAPON.NONE
const WeaponTyp = preload("res://Weapon/WeaponTypes.csv").records

var bulletScene

var scatter = 0.1
var cooldown = 0.05
var nozzel_speed = 50
var damage = 10
var display_name = "Gun"
var max_distance = 100
var ran = RandomNumberGenerator.new()
@onready var mountPoint = get_parent()
@onready var ship:Ship = mountPoint.get_parent()

func _ready():
	bulletScene = load(WeaponTyp[type]["missile_scene"])
	scatter = WeaponTyp[type]["scatter"]
	cooldown = WeaponTyp[type]["cooldown"]
	nozzel_speed = WeaponTyp[type]["nozzel_speed"]
	damage = WeaponTyp[type]["damage"]
	display_name = WeaponTyp[type]["display_name"]
	max_distance = WeaponTyp[type]["max_distance"]

func fire():
	if($Timer.time_left==0):	

		$Timer.start(cooldown)
		var bullet = bulletScene.instantiate()	
		bullet.speed = nozzel_speed
		bullet.damage = damage
		bullet.max_distance = max_distance * ran.randf_range(1,1+scatter)		
		bullet.transform = $BulletPoint.global_transform
		get_node("/root/Sol").add_child(bullet)
		var offset_velocity:Vector3  = ship.linear_velocity			
		bullet.velocity += offset_velocity
		var noise = Vector3(ran.randfn(0,scatter),0,ran.randfn(0,scatter))
		bullet.velocity += noise
		bullet.team = ship.team
		return true
	return false


