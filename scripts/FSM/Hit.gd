class_name Hit
extends PlayerState

@onready var hurtbox = $"../../hurtbox"
var hitVector : Vector2

func enter():
	print("Now Hit")
	animation_player.play("iFrames")
	
	# handles player knockback on damage
	hitVector = hurtbox.global_position - hurtbox.hitboxes[0].global_position
	player.velocity.x = (120 * (hitVector.x / 10))
	player.velocity.y = (100 * (hitVector.y / 10)) - 50
	
func exit():
	player.velocity.x *= 0.1
	
func update(delta : float):
	pass
	
func physics_update(delta : float):
	pass
	
func state_check():
	if !player.is_on_floor():
		transitioned.emit(self, "airborne")
	else:
		transitioned.emit(self, "idle")
