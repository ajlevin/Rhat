class_name Spawn
extends PlayerState

func enter():
	print("Now Spawning")
	
func exit():
	pass
	
func update(delta : float):
	pass
	
func physics_update(delta : float):
	transitioned.emit(self, "idle")

