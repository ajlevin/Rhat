class_name Airborne
extends PlayerState

func enter():
	print("Now Airborne")
	animation_player.play("RESET")

func exit():
	pass
	
func update(_delta : float):
	pass
	
func physics_update(delta : float):
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	if Input.is_action_just_released("jump") && player.velocity.y < -40:
		player.velocity.y *= 0.1

	# ! the direction.x is lower when up and down are pressed simultaneously !
	player.velocity.x = direction.x * stats.SPEED
	player.velocity.y = min(
		player.velocity.y + (stats.GRAVITY * delta), stats.TERMINAL_VELOCITY)
	
	if (direction.x > 0):
		player.sprite.flip_h = false
	elif (direction.x < 0):
		player.sprite.flip_h = true
	
	state_check(direction)

func into_wall(xDirection : float) -> bool :
	return (left_wall_ray.is_colliding() and xDirection > 0) or \
		(right_wall_ray.is_colliding() and xDirection < 0)

func state_check(direction : Vector2):
	if player.is_on_wall_only() and into_wall(direction.x):
		transitioned.emit(self, "onwall")
		
	if player.is_on_floor():
		transitioned.emit(self, "idle")
