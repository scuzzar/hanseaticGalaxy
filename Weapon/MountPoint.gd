@tool
extends Node3D

class_name mount_point

@export
var mount = ENUMS.WEAPON.NONE 
const WeaponTyp = preload("res://Weapon/WeaponTypes.csv").records
var turn_rate = 20

@export 
var turn_limit = 15/360*2*PI

@onready 
var no_turn_transform = self.transform

func _ready():
	do_mount()

func set_mount(new_mount):
	mount = new_mount
	if(mount==ENUMS.WEAPON.NONE):
		self.remove_child(self.get_children()[0])
	else:
		do_mount()

func do_mount():
	if(mount!=ENUMS.WEAPON.NONE):
		var gunScene = load(WeaponTyp[mount]["gun_scene"])		
		var gun = gunScene.instantiate()		
		gun.type = mount		
		self.add_child(gun)

func fire():
	if(mount!=ENUMS.WEAPON.NONE):
		return self.get_child(0).fire()

func get_weapon_speed():
	if(mount!=ENUMS.WEAPON.NONE):
		return WeaponTyp[mount]["nozzel_speed"]
	else:
		return 0
