class_name Run
extends PlayerState

func enter():
	print("Now Running")
	player.velocity.y = 0
	stats.extraJump = true
	stats.wasOnFloor = true
	stats.coyoteTime = false
	animation_player.play("run")
	
func exit():
	pass
	
func update(_delta : float):
	pass
	
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
	
func state_check(direction : Vector2):
	if !direction.x:
		transitioned.emit(self, "idle")
		
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "jump")
		
	if !player.is_on_floor():
		transitioned.emit(self, "airborne")
