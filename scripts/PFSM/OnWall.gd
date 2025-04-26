class_name OnWall
extends PlayerState

var wallDirection : int

### Sets which direction the wall being latched to is
func enter() -> void:
	wallDirection = -1 if left_wall_ray.is_colliding() else 1
	animated_sprite.position.x -= wallDirection * 4
	animated_sprite.play("wallSlide")
	
func exit() -> void:
	animated_sprite.position.x += wallDirection * 4
	
func update(_delta : float) -> void:
	pass
	
### Gets directional input and holds the player to the wall
func physics_update(_delta : float) -> void:
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up") \
		if stats.actionable \
		else Vector2.ZERO
	
	player.velocity.y = stats.WALL_SLIDE_VELOCITY
	
	state_check(direction)

### Checks if the player is holding into the wall
func into_wall(xDirection : float) -> bool :
	return (left_wall_ray.is_colliding() and xDirection < 0) or \
		(right_wall_ray.is_colliding() and xDirection > 0)

### Checks if the player has left the wall for any reason
func state_check(direction : Vector2) -> void:
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	elif Input.is_action_just_pressed("burst") and stats.get_actionable() and stats.get_burstCharges() > 0:
		transitioned.emit(self, "burst")
	elif Input.is_action_just_pressed("dash") and stats.get_dash():
		transitioned.emit(self, "dash")
	elif Input.is_action_just_pressed("jump") and stats.get_actionable():
		stats.wallKicking = -wallDirection
		transitioned.emit(self, "jump")
	elif !into_wall(direction.x): 
		transitioned.emit(self, "airborne")
	elif Input.is_action_just_pressed("attack") and stats.get_actionable():
		transitioned.emit(self, "melee")
	elif Input.is_action_just_pressed("special") and stats.get_actionable():
		transitioned.emit(self, "blast")
	elif Input.is_action_just_pressed("counter") and stats.get_actionable():
		transitioned.emit(self, "counter")
