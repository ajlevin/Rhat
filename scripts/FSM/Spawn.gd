class_name Spawn
extends PlayerState

### Disables player action during spawn sequence
func enter():
	print("Now Spawning")
	stats.actionable = false
	
### Enables player action on spawn completion
func exit():
	stats.actionable = true
	
func update(_delta : float):
	pass
	
### Accelerates the player with gravity if not grounded
func physics_update(delta : float):
	if !player.is_on_floor():
		player.velocity.y = min(
			player.velocity.y + (stats.GRAVITY * delta), 
			stats.TERMINAL_VELOCITY)
			
	state_check()

### Checks which state the player belongs to on exit
func state_check():
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")
