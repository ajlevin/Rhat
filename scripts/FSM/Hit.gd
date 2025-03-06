class_name Hit
extends PlayerState

@onready var hurtbox : Hurtbox = $"../../hurtbox"
var hitVector : Vector2

### Calculates the direction and force of knockback from the hit
func enter() -> void:
	print("Now Hit")
	animation_player.play("iFrames")
	stats.wasOnFloor = false
	
	# handles player knockback on damage
	# ToDo: Tune to lurche at the start then slow instead of a linear bump
	hitVector = (hurtbox.global_position - hurtbox.hitboxes[0].global_position).normalized()
	player.velocity.x = 140 * (hitVector.x)
	player.velocity.y = 120 * (hitVector.y) - 50
	
### Reduces the player's velocity as it comes out of hitstun
func exit() -> void:
	player.velocity.x *= 0.2
	
func update(_delta : float) -> void:
	pass
	
func physics_update(_delta : float) -> void:
	pass
	
### Checks for which state to put the player back into after hitstun
func state_check() -> void:
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	if !player.is_on_floor():
		transitioned.emit(self, "airborne")
	elif Input.is_action_just_pressed("dash") and stats.dash:
		transitioned.emit(self, "dash")
	elif direction.x != 0:
		transitioned.emit(self, "run")
	else:
		transitioned.emit(self, "idle")
