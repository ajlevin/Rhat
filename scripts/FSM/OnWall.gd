class_name OnWall
extends PlayerState

var wallDirection : float
@onready var kick_timer = $"../../Timers/KickTimer"

#####################################################
###! UNABLE TO BE ENTERED DUE TO RAYCAST2D BS RN !###
#####################################################

### Sets which direction the wall being latched to is
func enter() -> void:
	print("Now OnWall")
	wallDirection = 1 if left_wall_ray.is_colliding() else -1
	
func exit() -> void:
	pass
	
func update(_delta : float) -> void:
	pass
	
### Gets directional input and holds the player to the wall
func physics_update(_delta : float) -> void:
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	player.velocity.y = 0
	
	if Input.is_action_just_pressed("jump"):
		stats.actionable = false
		player.velocity.x = wallDirection * 100
		kick_timer.start(stats.KICK_TIMER_DURATION)
	
	state_check(direction)

### Checks if the player is holding into the wall
func into_wall(xDirection : float) -> bool :
	return (left_wall_ray.is_colliding() and xDirection < 0) or \
		(right_wall_ray.is_colliding() and xDirection > 0)

### Renables player action and refreshes the dobule jump
func _on_kick_timer_timeout() -> void:
	stats.extraJump = true
	stats.actionable = true

### Checks if the player has left the wall for any reason
func state_check(direction : Vector2) -> void:
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	
	if !player.is_on_wall_only() or !into_wall(direction.x): 
		transitioned.emit(self, "airborne")
	
	# ! RUH ROH SWAP TO JUMP??????? !
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = stats.JUMP_VELOCITY
		player.velocity.x = stats.KICK_SPEED * direction.x
		transitioned.emit(self, "airborne")
