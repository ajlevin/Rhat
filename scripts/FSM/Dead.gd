class_name Dead
extends PlayerState

func enter():
	print("Now Dead")
	
	player.velocity.x = 0
	animation_player.play("death")
	
func exit():
	pass
	  
func update(delta : float):
	pass
	
func physics_update(delta : float):
	pass

func reload_scene():
	get_tree().reload_current_scene()
