class_name NemDead
extends NemState

### Set player horizantal velocity to 0 and begin the death sequence
func enter() -> void:
	print("Nem Now Dead")
	
	stats.actionable = false
	nemesis.velocity.x = 0
	animation_player.play("death")
	
func exit() -> void:
	pass
	  
func update(_delta : float) -> void:
	pass
	
### Maintain vertical acceleration due to gravity
func physics_update(delta : float) -> void:
	nemesis.velocity.y = min(
		nemesis.velocity.y + (stats.GRAVITY * delta), stats.TERMINAL_VELOCITY)

### Reset the entire game tree (used on death)
func reload_scene() -> void:
	get_tree().reload_current_scene()
