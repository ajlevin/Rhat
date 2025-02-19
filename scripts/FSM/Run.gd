class_name Run
extends PlayerState

func enter():
	print("Now Running")
	animation_player.play("run")
	
func exit():
	pass
	
func update(delta : float):
	pass
	
func physics_update(delta : float):
	var direction = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")

	# ! the direction.x is lower when up and down are pressed simultaneously !
	player.velocity.x = direction.x * stats.SPEED
	
	if (direction.x > 0):
		player.sprite.flip_h = false
	elif (direction.x < 0):
		player.sprite.flip_h = true
	state_check(direction)
	
func state_check(direction : Vector2):
	if !direction.x:
		transitioned.emit(self, "idle")
		
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = stats.JUMP_VELOCITY
		transitioned.emit(self, "airborne")
		
	if !player.is_on_floor():
		transitioned.emit(self, "airborne")
