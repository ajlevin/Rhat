class_name OnWall
extends PlayerState

func enter():
	print("Now OnWall")
	
func exit():
	pass
	
func update(delta : float):
	pass
	
func physics_update(delta : float):
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	player.velocity.y = 0
	
	state_check(direction)

func into_wall(xDirection : float) -> bool :
	return (left_wall_ray.is_colliding() and xDirection > 0) or \
		(right_wall_ray.is_colliding() and xDirection < 0)

func state_check(direction : Vector2):
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	if !player.is_on_wall_only() or !into_wall(direction.x): 
		transitioned.emit(self, "airborne")
