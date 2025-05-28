class_name NemIdle
extends NemState

### Resets all velocities and buffering stats to defaults
func enter() -> void:
	nemesis.velocity.x = 0
	nemesis.velocity.y = 0

	stats.extraJump = true
	if !animation_player.current_animation == "iFrames":
		animation_player.play("RESET")
	
func exit() -> void:
	pass
	
func update(delta : float) -> void:
	pass
	
### Collections directional input and state checks
func physics_update(delta : float) -> void:
	var direction : Vector2 = ndc.getPlayerDirection()
	
	state_check(direction)

### Checks to see if the player has done literally anything
func state_check(direction : Vector2) -> void:	
	var nInput = ndc.getCurInput()

	match nInput:
		ndc.NemInput.Run:
			if ndc.requiresJump():
				transitioned.emit(self, "nemjump")
			elif nemesis.is_on_floor():
				transitioned.emit(self, "nemrun")
			else:
				transitioned.emit(self, "nemairborne")
		ndc.NemInput.Burst:
			transitioned.emit(self, "nemburst")
		ndc.NemInput.Counter:
			transitioned.emit(self, "nemcounter")
		ndc.NemInput.Melee:
			transitioned.emit(self, "nemmelee")
		ndc.NemInput.Blast:
			transitioned.emit(self, "nemblast")
		ndc.NemInput.Dash:
			if stats.get_dash():
				transitioned.emit(self, "nemdash")
			else:
				transitioned.emit(self, "nemrun")
		_:
			pass
