class_name Run
extends PlayerState

func enter() -> void:
	print("Now Running")
	player.velocity.y = 0
	stats.extraJump = true
	stats.wasOnFloor = true
	stats.coyoteTime = false
	
	###! This doesn't fully work either as it should update when that ends !###
	if !animation_player.current_animation == "iFrames":
		animation_player.play("run")
	
func exit() -> void:
	pass
	
func update(_delta : float) -> void:
	pass
	
### Gets directional input and adjusts horizantal velocity accordingly
func physics_update(_delta : float) -> void:
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up") \
		if stats.actionable \
		else Vector2.ZERO

	# ! the direction.x is lower when up and down are pressed simultaneously !
	player.velocity.x = direction.x * stats.SPEED
	
	if (direction.x > 0):
		animated_sprite.flip_h = false
	elif (direction.x < 0):
		animated_sprite.flip_h = true
	state_check(direction)
	
### Checks if the player has left the ground or stopped moving
func state_check(direction : Vector2) -> void:
	if !direction.x:
		transitioned.emit(self, "idle")
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
