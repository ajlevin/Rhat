class_name Airborne
extends State

@onready var player = $"../.."

func enter():
	pass
	
func exit():
	pass
	
func update(delta : float):
	pass
	
func physics_update(delta : float):
	
	if player.is_on_floor():
		transitioned.emit(self, "idle")

