class_name Jump
extends PlayerState

### Updates floor tracking for coyote time and adds jump velocity
func enter():
	print("Now Jumping")
	animation_player.play("RESET")
	stats.wasOnFloor = false
	player.velocity.y = stats.JUMP_VELOCITY
	
### Cuts jump short should the button be released before the apex
func exit():
	if player.velocity.y < -40:
		player.velocity.y *= 0.1
	
func update(_delta : float):
	pass
	
### Collects directional input and updates the player's velocities to match
func physics_update(delta : float):
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	player.velocity.x = direction.x * stats.SPEED
	player.velocity.y = min(
			player.velocity.y + (stats.GRAVITY * delta), 
			stats.TERMINAL_VELOCITY)
		
	if (direction.x > 0):
		animated_sprite.flip_h = false
	elif (direction.x < 0):
		animated_sprite.flip_h = true 
			
	state_check(direction)
	
### Checks if the jump has ended, either by landing or the input being released
func state_check(direction : Vector2):
	if player.is_on_floor():
		if direction.x != 0:
			transitioned.emit(self, "run")
		else:
			transitioned.emit(self, "idle")
	elif Input.is_action_just_released("jump"):
		transitioned.emit(self, "airborne")
