class_name NemIdle
extends NemState

### Resets all velocities and buffering stats to defaults
func enter() -> void:
	print("Nem Now Idle")
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
	if ndc.withinAttackRange() != 0:
		transitioned.emit(self, "nemmelee")
	
	if direction.x != 0:
		transitioned.emit(self, "nemrun")
	#elif Input.is_action_just_pressed("dash") and stats.get_dash() and stats.get_actionable():
		#transitioned.emit(self, "dash")
	#elif Input.is_action_just_pressed("jump") and stats.get_actionable():
		#transitioned.emit(self, "jump")
	elif !nemesis.is_on_floor():
		transitioned.emit(self, "nemairborne")
	#elif Input.is_action_just_pressed("attack") and stats.get_actionable():
		#transitioned.emit(self, "melee")
	#elif Input.is_action_just_pressed("special") and stats.get_actionable():
		#transitioned.emit(self, "blast")
		
	
