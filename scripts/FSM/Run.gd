class_name Run
extends PlayerState

func enter():
	print("Now Running")
	player.velocity.y = 0
	stats.extraJump = true
	stats.wasOnFloor = true
	stats.coyoteTime = false
	
	###! This doesn't fully work either as it should update when that ends !###
	if !animation_player.current_animation == "iFrames":
		animation_player.play("run")
	
func exit():
	pass
	
func update(_delta : float):
	pass
	
### Gets directional input and adjusts horizantal velocity accordingly
func physics_update(_delta : float):
	var direction = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")

	# ! the direction.x is lower when up and down are pressed simultaneously !
	player.velocity.x = direction.x * stats.SPEED
	
	if (direction.x > 0):
		animated_sprite.flip_h = false
	elif (direction.x < 0):
		animated_sprite.flip_h = true
	state_check(direction)
	
### Checks if the player has left the ground or stopped moving
func state_check(direction : Vector2):
	if !direction.x:
		transitioned.emit(self, "idle")
	elif Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "jump")	
	elif !player.is_on_floor():
		transitioned.emit(self, "airborne")
	elif Input.is_action_just_pressed("attack"):
		transitioned.emit(self, "attack")
