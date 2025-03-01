class_name Attack
extends PlayerState

func enter():
	print("Now Attacking")
	player.velocity.x = 0
	player.velocity.y = 0
	animation_player.play("melee")
	
func exit():
	pass
	
func update(_delta : float):
	pass
	
func physics_update(_delta : float):
	pass

func state_check():
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")
