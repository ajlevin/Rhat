class_name OnWall
extends PlayerState

var wallDirection : float
@onready var kick_timer = $"../../Timers/KickTimer"

func enter():
	print("Now OnWall")
	wallDirection = 1 if left_wall_ray.is_colliding() else -1
	
func exit():
	pass
	
func update(_delta : float):
	pass
	
func physics_update(_delta : float):
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	player.velocity.y = 0
	
	if Input.is_action_just_pressed("jump"):
		stats.actionable = false
		player.velocity.x = wallDirection * 100
		kick_timer.start(stats.KICK_TIMER_DURATION)
	
	state_check(direction)

func into_wall(xDirection : float) -> bool :
	return (left_wall_ray.is_colliding() and xDirection > 0) or \
		(right_wall_ray.is_colliding() and xDirection < 0)

func _on_kick_timer_timeout():
	stats.extraJump = true
	stats.actionable = true

func state_check(direction : Vector2):
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	
	if !player.is_on_wall_only() or !into_wall(direction.x): 
		transitioned.emit(self, "airborne")
	
	# ! RUH ROH SWAP TO JUMP??????? !
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = stats.JUMP_VELOCITY
		player.velocity.x = stats.KICK_SPEED * direction.x
		transitioned.emit(self, "airborne")
