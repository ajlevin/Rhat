class_name NemJump
extends NemState

@onready var kick_timer = $"../../Timers/KickTimer"

### Updates floor tracking for coyote time and adds jump velocity
func enter() -> void:	
	if stats.wallKicking != 0:
		nemesis.velocity.y = stats.JUMP_VELOCITY
		nemesis.velocity.x = stats.KICK_VELOCITY * stats.wallKicking
		kick_timer.start(stats.KICK_TIMER_DURATION)
	else:
		nemesis.velocity.y = stats.JUMP_VELOCITY
	
	if !animation_player.current_animation == "iFrames":
		animation_player.play("RESET")
	
### Cuts jump short should the button be released before the apex
func exit() -> void:
	if nemesis.velocity.y < -40:
		nemesis.velocity.y *= 0.1
	
func update(_delta : float) -> void:
	pass
	
### Collects directional input and updates the player's velocities to match
func physics_update(delta : float) -> void:
	var direction : Vector2 =  ndc.getPlayerDirection()
	
	nemesis.velocity.x = direction.x * stats.SPEED
	nemesis.velocity.y = min(
			nemesis.velocity.y + (stats.GRAVITY * delta), 
			stats.TERMINAL_VELOCITY)
		
	if (direction.x > 0):
		animated_sprite.flip_h = false
	elif (direction.x < 0):
		animated_sprite.flip_h = true 
			
	state_check(direction)
	
### Renables player action and refreshes the dobule jump
func _on_kick_timer_timeout() -> void:
	stats.wallKicking = 0
	stats.extraJump = true
	stats.actionable = true

### Checks if the jump has ended, either by landing or the input being released
func state_check(direction : Vector2) -> void:
	var nInput = ndc.getCurInput()
	
	match nInput:
		ndc.NemInput.Run:
			if ndc.requiresJump():
				transitioned.emit(self, "nemjump")
			elif ndc.maintainJump():
				pass
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
	
	#if nemesis.is_on_floor():
		#if direction.x != 0:
			#transitioned.emit(self, "nemrun")
		#else:
			#transitioned.emit(self, "nemidle")
	#elif (direction.y > -0.1 and (stats.wallKicking == 0)) \
		#or nemesis.velocity.y >= 0:
		#transitioned.emit(self, "nemairborne")
	#elif nemesis.velocity.y >= 0 and stats.extraJump and direction.y < -0.4:
		#stats.extraJump = false
		#transitioned.emit(self, "nemjump")
	#elif Input.is_action_just_pressed("dash") and stats.get_dash():
		#transitioned.emit(self, "nemdash")
	#elif Input.is_action_just_pressed("attack"):
		#transitioned.emit(self, "nemmelee")
	#elif Input.is_action_just_pressed("special"):
		#transitioned.emit(self, "nemblast")
