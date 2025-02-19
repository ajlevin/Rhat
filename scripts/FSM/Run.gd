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

	player.velocity.x = direction.x * stats.SPEED
	
	state_check(direction)
	
func state_check(direction : Vector2):
	if !direction.x:
		transitioned.emit(self, "idle")
		
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = stats.JUMP_VELOCITY
		transitioned.emit(self, "airborne")
