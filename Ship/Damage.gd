extends Node

onready var ship :RigidBody = $"../"

func handle_collsions(state:PhysicsDirectBodyState):
	if(state.get_contact_count()!=0):
		var colliding_body = state.get_contact_collider_object(0)
		var impulseSum = 0
		for i in state.get_contact_count():
			impulseSum += state.get_contact_impulse(i)
						
		self._on_impact(colliding_body,impulseSum)


func _on_impact(colliding_body:RigidBody,impulse:float):
	if(impulse>40):
		ship.takeDamege(impulse/5*ship.max_hitpoints/100)
		print(impulse)
