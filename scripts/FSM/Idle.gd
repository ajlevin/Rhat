class_name Idle
extends State

@onready var player = $"../.."

func enter():
	pass
	
func exit():
	pass
	
func update(delta : float):
	pass
	
func physics_update(delta : float):
	var direction = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	if direction.x != 0:
		transitioned.emit(self, "run")
		
	if Input.is_action_just_pressed("jump") or \
		(player.is_on_floor() and player.jumpBuffered):
		transitioned.emit(self, "airborne")
