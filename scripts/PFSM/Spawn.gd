class_name Spawn
extends PlayerState

### Disables player action during spawn sequence
func enter() -> void:
	stats.actionable = false

### Enables player action on spawn completion
func exit() -> void:
	stats.set_actionable(true)
	stats.set_immortality(false)
	
func update(_delta : float) -> void:
	pass
	
### Accelerates the player with gravity if not grounded
func physics_update(delta : float) -> void:
	if !player.is_on_floor():
		player.velocity.y = min(
			player.velocity.y + (stats.GRAVITY * delta), 
			stats.TERMINAL_VELOCITY)
			
	state_check()

### Checks which state the player belongs to on exit
func state_check() -> void:
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")
