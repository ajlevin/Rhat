class_name Dead
extends PlayerState

### Set player horizantal velocity to 0 and begin the death sequence
func enter() -> void:
	print("Now Dead")
	
	stats.actionable = false
	player.velocity.x = 0
	animation_player.play("death")
	
func exit() -> void:
	pass
	  
func update(_delta : float) -> void:
	pass
	
### Maintain vertical acceleration due to gravity
func physics_update(delta : float) -> void:
	player.velocity.y = min(
		player.velocity.y + (stats.GRAVITY * delta), stats.TERMINAL_VELOCITY)

### Reset the entire game tree (used on death)
func reload_scene() -> void:
	get_tree().reload_current_scene()
