class_name Idle
extends PlayerState

### Resets all velocities and buffering stats to defaults
func enter() -> void:
	player.velocity.x = 0
	player.velocity.y = 0
	stats.wasOnFloor = true
	stats.coyoteTime = false

	stats.extraJump = true
	if !animation_player.current_animation == "iFrames":
		animation_player.play("RESET")
	
func exit() -> void:
	pass
	
func update(delta : float) -> void:
	pass
	
### Collections directional input and state checks
func physics_update(delta : float) -> void:
	var direction = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	state_check(direction)
		
### Checks to see if the player has done literally anything
func state_check(direction : Vector2) -> void:
	if direction.x != 0 and stats.get_actionable():
		transitioned.emit(self, "run")
	elif Input.is_action_just_pressed("dash") and stats.get_dash() and stats.get_actionable():
		transitioned.emit(self, "dash")
	elif Input.is_action_just_pressed("jump") and stats.get_actionable():
		transitioned.emit(self, "jump")
	elif !player.is_on_floor():
		transitioned.emit(self, "airborne")
	elif Input.is_action_just_pressed("attack") and stats.get_actionable():
		transitioned.emit(self, "melee")
	elif Input.is_action_just_pressed("special") and stats.get_actionable():
		transitioned.emit(self, "blast")
	elif Input.is_action_just_pressed("counter") and stats.get_actionable():
		transitioned.emit(self, "counter")
		
	
