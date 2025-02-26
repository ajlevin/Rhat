class_name Dead
extends PlayerState

### Set player horizantal velocity to 0 and begin the death sequence
func enter():
	print("Now Dead")
	
	player.velocity.x = 0
	animation_player.play("death")
	
func exit():
	pass
	  
func update(_delta : float):
	pass
	
### Maintain vertical acceleration due to gravity
func physics_update(delta : float):
	player.velocity.y = min(
		player.velocity.y + (stats.GRAVITY * delta), stats.TERMINAL_VELOCITY)

### Reset the entire game tree (used on death)
func reload_scene():
	get_tree().reload_current_scene()
