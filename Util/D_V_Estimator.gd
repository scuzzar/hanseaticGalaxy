extends Node

class_name D_V_Estimator

static func mission_time(mission:DeliveryMission, acc_d_v_float=0):
	var A:Port = mission.origin
	var B:Port = mission.destination
	
	var P_A:simpelPlanet = A.getBody()
	var P_B:simpelPlanet  = B.getBody()
	
	var innerPlanet:simpelPlanet
	var outerPlanet:simpelPlanet
	
	# if moon select planet
	if(!P_A.isPlanet):
		P_A = P_A.get_parent()	
	if(!P_B.isPlanet):
		P_B = P_B.get_parent()
	
	
	if(P_A.radius<P_B.radius):
		innerPlanet=P_A
		outerPlanet=P_B
	else:
		innerPlanet=P_B
		outerPlanet=P_A

	var r_e = innerPlanet.orbit_radius
	var r_a = outerPlanet.orbit_radius
	
	var sun:simpelPlanet = P_A.get_parent()

	var time = PI * sqrt(pow(r_e+r_a,3)/(8*Globals.G*sun.mass))
	
	var acc_reduction = transfer_delta_v(innerPlanet,outerPlanet)
	
	return time/Globals.GameYear*12

static func mission_d_v(mission:DeliveryMission):
	
	var A:Port = mission.origin
	var B:Port = mission.destination
	
	var P_A:simpelPlanet = A.getBody()
	var P_B:simpelPlanet  = B.getBody()
	
	var transfer_d_v=transfer_delta_v(P_A,P_B)	
	var escape = 0
	if(A is SpaceStation):	
		var A_Sat:Satellite =((A as SpaceStation).get_parent() as Satellite)
		var A_Station_Orbit_r = A_Sat.orbit_radius
		var A_Station_Speed = A_Sat.linear_velocity.length()
		if(P_A==P_B):
			escape += A_Station_Speed
		else:
			escape += escape_d_v(P_A, A_Station_Orbit_r)
	else:
		escape =  escape_surface_d_v(P_A)
		if(!P_A.isPlanet):
			escape += escape_d_v(P_A.get_parent(),P_A.orbit_radius)
		
	
	
	var landing_dv = 0
	if(B is SpaceStation):
		var B_Sat:Satellite =((B as SpaceStation).get_parent() as Satellite)
		var B_Station_Orbit_r = B_Sat.orbit_radius
		var B_Station_Speed = B_Sat.linear_velocity.length()
		if(P_A==P_B):
			landing_dv = 0
		else:
			
			landing_dv = escape_d_v(P_B, B_Station_Orbit_r) - B_Station_Speed
			print(landing_dv)
	else:
		landing_dv = escape_surface_d_v(P_B)
	
	return transfer_d_v + escape + landing_dv

static func transfer_delta_v(pA:simpelPlanet,pB:simpelPlanet):
	var A = pA
	var B = pB
	if(!A.isPlanet):
		A = A.get_parent()
	
	if(!B.isPlanet):
		B = B.get_parent()
	
	var innerPlanet:simpelPlanet
	var outerPlanet:simpelPlanet
	
	if(A.radius<B.radius):
		innerPlanet=A
		outerPlanet=B
	else:
		innerPlanet=B
		outerPlanet=A
	
	var r_e = innerPlanet.orbit_radius
	var r_a = outerPlanet.orbit_radius
	
	var v_e = innerPlanet.orbital_speed
	var v_a = outerPlanet.orbital_speed
	if(v_e==0):v_e = Globals.velocity_shift.length()
	if(v_a==0):v_a = Globals.velocity_shift.length()
	
	var d_v_e = v_e * (sqrt(2*r_a/(r_e+r_a))-1)
	var d_v_a = v_a * (1-sqrt(2*r_e/(r_e+r_a)))
	var d_v= d_v_a+d_v_e
	
	#print(innerPlanet.name + "->" + outerPlanet.name + " dv:" + str(d_v_e) + " +" + str(d_v_a) + " ="+ str(d_v))
	
	
	return d_v

static func escape_surface_d_v(planet:simpelPlanet):
	return escape_d_v(planet,planet.radius)

static func escape_d_v(planet:simpelPlanet, r:float):	
	var G = Globals.G
	var M = planet.mass
	var kosmic = sqrt(G*M/r)
	var escape = kosmic * sqrt(2)
	return escape
