class_name Idle
extends PlayerState

func enter():
	print("Now Idle")
	player.velocity.x = 0
	player.velocity.y = 0
	animation_player.play("RESET")
	
func exit():
	pass
	
func update(delta : float):
	pass
	
func physics_update(delta : float):
	var direction = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	state_check(direction)
		
func state_check(direction : Vector2):
	if direction.x != 0:
		transitioned.emit(self, "run")
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = stats.JUMP_VELOCITY
		transitioned.emit(self, "airborne")
	
	if Input.is_action_just_pressed("jump") or \
		(player.is_on_floor() and player.jumpBuffered):
		transitioned.emit(self, "airborne")
