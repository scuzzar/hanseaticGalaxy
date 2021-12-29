tool
extends Spatial

class_name mount_point

export(ENUMS.WEAPON) var mount = ENUMS.WEAPON.NONE setget set_mount
const WeaponTyp = preload("res://Weapon/WeaponTypes.csv").records

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
		var gun = gunScene.instance()
		print(gun.type)
		gun.type = mount		
		self.add_child(gun)

func fire():
	if(mount!=ENUMS.WEAPON.NONE):
		return self.get_child(0).fire()

