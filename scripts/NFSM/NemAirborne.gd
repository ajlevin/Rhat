class_name NemAirborne
extends NemState

@onready var down: RayCast2D = $"../../Rays/down"

func enter() -> void:	
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
	var nInput = ndc.getCurInput()
	
	match nInput:
		ndc.NemInput.Run:
			if ndc.requiresJump():
				transitioned.emit(self, "nemjump")
			elif nemesis.is_on_floor():
				transitioned.emit(self, "nemrun")
		ndc.NemInput.Burst:
			transitioned.emit(self, "nemburst")
		ndc.NemInput.Counter:
			transitioned.emit(self, "nemcounter")
		ndc.NemInput.Melee:
			transitioned.emit(self, "nemmelee")
		ndc.NemInput.Blast:
			transitioned.emit(self, "nemblast")
		ndc.NemInput.Dash:
			if stats.get_dash():
				transitioned.emit(self, "nemdash")
		ndc.NemInput.Jump:
			if stats.extraJump:
				stats.extraJump = false
				transitioned.emit(self, "nemjump")
		_:
			pass
