class_name NemAirborne
extends NemState

@onready var down: RayCast2D = $"../../Rays/down"

func enter() -> void:
	print("Nem Now Airborne")
	
	if !animation_player.current_animation == "iFrames":
		animation_player.play("RESET")

func exit() -> void:
	pass
	
func update(_delta : float) -> void:
	pass
	
func physics_update(delta : float) -> void:
	var direction : Vector2 = ndc.getPlayerDirection()
	
	# bump player if nearly colliding with ceiling
	if right_ray.is_colliding() and \
		!(central_ray.is_colliding() or left_ray.is_colliding()):
			nemesis.position.x -= 5
	elif left_ray.is_colliding() and \
		!(central_ray.is_colliding() or right_ray.is_colliding()):
			nemesis.position.x += 5
	
	nemesis.velocity.x = direction.x * stats.SPEED
	
	nemesis.velocity.y = min(
		nemesis.velocity.y + (stats.GRAVITY * delta), 
		stats.TERMINAL_VELOCITY)

	# move somewhere else more general ??
	if (direction.x > 0):
		animated_sprite.flip_h = false
	elif (direction.x < 0):
		animated_sprite.flip_h = true 
	
	state_check(direction)

func into_wall(xDirection : float) -> bool :
	return (left_wall_ray.is_colliding() and xDirection < 0) or \
		(right_wall_ray.is_colliding() and xDirection > 0)

func state_check(direction : Vector2) -> void:
	if nemesis.is_on_floor():
		if direction.x != 0:
			transitioned.emit(self, "nemrun")
		else:
			transitioned.emit(self, "nemidle")
	elif down.is_colliding() && stats.get_dash():
		transitioned.emit(self, "nemdash")
	elif into_wall(direction.x):
		transitioned.emit(self, "nemonwall")
	#elif Input.is_action_just_pressed("dash") and stats.get_dash() and stats.get_actionable():
		#transitioned.emit(self, "dash")
	#elif Input.is_action_just_pressed("attack") and stats.get_actionable():
		#transitioned.emit(self, "melee")
	#elif Input.is_action_just_pressed("special") and stats.get_actionable():
		#transitioned.emit(self, "blast")
	elif stats.extraJump and direction.y < -0.1:
		stats.extraJump = false
		transitioned.emit(self, "nemjump")
