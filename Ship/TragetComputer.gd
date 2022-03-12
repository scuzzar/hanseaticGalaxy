extends Node

@onready var ship = get_parent()



func _turn_turrents(delta):
	var position2D = get_viewport().get_mouse_position()
	var dropPlane  = Plane(Vector3(0, 1, 0), 0)
	var camera = get_viewport().get_camera()
	var position3D = dropPlane.intersects_ray(
		camera.project_ray_origin(position2D),
		camera.project_ray_normal(position2D))
	if(position3D!=null):
		for mount in ship.mounts :
			var ownTransform:Transform3D = mount.global_transform
			var look_transform = ownTransform.looking_at(position3D,Vector3(0,1,0))
			var angle = look_transform.basis.get_euler().y
			
			var nt:Transform3D = mount.no_turn_transform
			var st:Transform3D = ship.global_transform
			
			nt = nt.rotated(Vector3(0,1,0),st.basis.get_euler().y-PI/2)
			
			var n = nt.basis.get_euler().y
			var l = mount.turn_limit
			var n_max = nt.rotated(Vector3(0,1,0),l).basis.get_euler().y
			var n_min = nt.rotated(Vector3(0,1,0),l*-1).basis.get_euler().y
			
			var d = (look_transform.rotated(Vector3(0,1,0),nt.basis.get_euler().y*-1)).basis.get_euler().y
			#var d = (look_transform.rotated(Vector3(0,1,0),st.basis.get_euler().y*-1+PI)).basis.get_euler().y
			if(d>=l): angle = n_max
			if(d<=l*-1): angle = n_min
			
			var angleD = angle - ownTransform.basis.get_euler().y
			
			var turnrate =mount.turn_rate
			var turnAngle =angleD#  clamp(angleD,mount.turn_rate*-1*delta,mount.turn_rate*delta)
	
			(mount as Node3D).global_rotate(Vector3(0,1,0),turnAngle)
