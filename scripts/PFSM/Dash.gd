class_name Dash
extends PlayerState

@onready var dash_reset_timer: Timer = $"../../Timers/DashResetTimer"

### Sets vertical velocity to 0 and begins dash sequence
func enter() -> void:
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	if direction.x <= 0.1:
		direction.x = -1 if animated_sprite.flip_h else 1
	else:
		animated_sprite.flip_h = true if direction.x < 0 else false
		
	effect_sprite.flip_h = animated_sprite.flip_h
	effect_sprite.position = Vector2(15, 17) if animated_sprite.flip_h else Vector2(-15, 17)

	player.velocity.y = 0
	player.velocity.x = stats.DASH_VELOCITY * direction.x
	
	animation_player.play("dash")
	
### Begins dash cooldown timer
func exit() -> void:
	effect_sprite.play("blank")
	dash_reset_timer.start(stats.DASH_RESET_DURATION)

func update(delta : float) -> void:
	pass
	
### Collections directional input and state checks
func physics_update(delta : float) -> void:
	pass

### Reenables dash
func _on_dash_reset_timer_timeout() -> void:
	stats.set_dash(true)

### Checks to see if the player is airborne or grounded
func state_check() -> void:
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")
