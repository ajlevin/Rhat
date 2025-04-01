class_name Airborne
extends PlayerState

@onready var jump_buffer_timer : Timer = $"../../Timers/JumpBufferTimer"
@onready var coyote_timer : Timer = $"../../Timers/CoyoteTimer"

func enter() -> void:
	#if !animation_player.current_animation == "iFrames":
		#animation_player.play("RESET")
	animated_sprite.play("fall")

func exit() -> void:
	pass
	
func update(_delta : float) -> void:
	pass
	
func physics_update(delta : float) -> void:
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up") \
		if stats.actionable \
		else Vector2.ZERO
	
	# bump player if nearly colliding with ceiling
	if right_ray.is_colliding() and \
		!(central_ray.is_colliding() or left_ray.is_colliding()):
			player.position.x -= 5
	elif left_ray.is_colliding() and \
		!(central_ray.is_colliding() or right_ray.is_colliding()):
			player.position.x += 5
	
	# ! the direction.x is lower when up and down are pressed simultaneously !
	if stats.actionable:
		player.velocity.x = direction.x * stats.SPEED
	
	if stats.wasOnFloor:
		stats.coyoteTime = true
		coyote_timer.start(stats.COYOTE_TIME_DURATION)
		stats.wasOnFloor = false
	
	if Input.is_action_just_pressed("jump") and stats.actionable and \
		!(player.is_on_floor() or stats.extraJump):
		stats.jumpBuffered = true
		jump_buffer_timer.start(stats.JUMP_BUFFER_DURATION)
	
	player.velocity.y = min(
		player.velocity.y + (stats.GRAVITY * delta), 
		stats.TERMINAL_VELOCITY)

	# move somewhere else more general ??
	if (direction.x > 0):
		animated_sprite.flip_h = false
	elif (direction.x < 0):
		animated_sprite.flip_h = true 
	
	state_check(direction)

func _on_jump_buffer_timer_timeout() -> void:
	stats.jumpBuffered = false

func _on_coyote_timer_timeout() -> void:
	stats.coyoteTime = false 

func into_wall(xDirection : float) -> bool :
	return (left_wall_ray.is_colliding() and xDirection < 0) or \
		(right_wall_ray.is_colliding() and xDirection > 0)

func state_check(direction : Vector2) -> void:
	if player.is_on_floor():
		if stats.jumpBuffered:
			transitioned.emit(self, "jump")
		elif direction.x != 0 and stats.get_actionable():
			transitioned.emit(self, "run")
		else:
			transitioned.emit(self, "idle")
	elif Input.is_action_just_pressed("dash") and stats.get_dash() and stats.get_actionable():
		transitioned.emit(self, "dash")
	elif Input.is_action_just_pressed("attack") and stats.get_actionable():
		transitioned.emit(self, "melee")
	elif Input.is_action_just_pressed("special") and stats.get_actionable():
		transitioned.emit(self, "blast")
	elif Input.is_action_just_pressed("counter") and stats.get_actionable():
		transitioned.emit(self, "counter")
	elif into_wall(direction.x) and stats.get_actionable():
		transitioned.emit(self, "onwall")
	elif Input.is_action_just_pressed("jump") and \
		(stats.coyoteTime or stats.extraJump) and stats.get_actionable():
			if !stats.coyoteTime: 
				stats.extraJump = false
			stats.coyoteTime = false
			transitioned.emit(self, "jump")
