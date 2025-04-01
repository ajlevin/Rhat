class_name NemDash
extends NemState

@onready var dash_reset_timer: Timer = $"../../Timers/DashResetTimer"
@onready var down: RayCast2D = $"../../Rays/down"

### Sets vertical velocity to 0 and begins dash sequence
func enter() -> void:
	var direction : Vector2 = (Vector2(500, 317) - nemesis.global_position).normalized() \
		if down.is_colliding() \
		else ndc.getPlayerDirection()
	if direction.x <= 0.1:
		direction.x = -1 if animated_sprite.flip_h else 1

	nemesis.velocity.y = 0
	nemesis.velocity.x = stats.DASH_VELOCITY * direction.x
	
	animation_player.play("dash")
	
### Begins dash cooldown timer
func exit() -> void:
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
	if nemesis.is_on_floor():
		transitioned.emit(self, "nemidle")
	else:
		transitioned.emit(self, "nemairborne")
