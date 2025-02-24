class_name Idle
extends PlayerState

func enter():
	print("Now Idle")
	player.velocity.x = 0
	player.velocity.y = 0
	stats.wasOnFloor = true
	stats.coyoteTime = false

	stats.extraJump = true
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
		transitioned.emit(self, "jump")

	if !player.is_on_floor():
		transitioned.emit(self, "airborne")
