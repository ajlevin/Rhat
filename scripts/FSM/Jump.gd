class_name Jump
extends PlayerState

@onready var kick_timer = $"../../Timers/KickTimer"

### Updates floor tracking for coyote time and adds jump velocity
func enter() -> void:
	print("Now Jumping")
	stats.wasOnFloor = false
	
	if stats.wallKicking != 0:
		player.velocity.y = stats.JUMP_VELOCITY
		player.velocity.x = stats.KICK_VELOCITY * stats.wallKicking
		stats.actionable = false
		kick_timer.start(stats.KICK_TIMER_DURATION)
	else:
		player.velocity.y = stats.JUMP_VELOCITY
	
	if !animation_player.current_animation == "iFrames":
		animation_player.play("RESET")
	
### Cuts jump short should the button be released before the apex
func exit() -> void:
	if player.velocity.y < -40:
		player.velocity.y *= 0.1
	
func update(_delta : float) -> void:
	pass
	
### Collects directional input and updates the player's velocities to match
func physics_update(delta : float) -> void:
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up") \
		if stats.actionable \
		else Vector2.ZERO
	
	if stats.actionable:
		player.velocity.x = direction.x * stats.SPEED
	player.velocity.y = min(
			player.velocity.y + (stats.GRAVITY * delta), 
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
	if player.is_on_floor():
		if direction.x != 0 and stats.get_actionable():
			transitioned.emit(self, "run")
		else:
			transitioned.emit(self, "idle")
	elif Input.is_action_just_released("jump") or \
		(!stats.actionable and stats.wallKicking == 0):
		transitioned.emit(self, "airborne")
	elif Input.is_action_just_pressed("dash") and stats.get_dash():
		transitioned.emit(self, "dash")
	elif Input.is_action_just_pressed("attack") and stats.get_actionable():
		transitioned.emit(self, "melee")
	elif Input.is_action_just_pressed("special") and stats.get_actionable():
		transitioned.emit(self, "blast")
