class_name Spawn
extends PlayerState

func enter():
	print("Now Spawning")
	stats.actionable = false
	
func exit():
	stats.actionable = true
	
func update(_delta : float):
	pass
	
func physics_update(delta : float):
	if !player.is_on_floor():
		player.velocity.y = min(
			player.velocity.y + (stats.GRAVITY * delta), 
			stats.TERMINAL_VELOCITY)
			
	state_check()
	
func state_check():
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")

