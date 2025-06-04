class_name Hit
extends PlayerState

@onready var hurtbox : Hurtbox = $"../../hurtbox"
@onready var freaky_timer: Timer = $"../../Timers/FreakyTimer"
var hitVector : Vector2
var lastHitDmg : int = 0

### Calculates the direction and force of knockback from the hit
func enter() -> void:
	if lastHitDmg > 1:
		hitFreeze(0.02, 0.5)
	animation_player.play("iFrames")
	stats.wasOnFloor = false
	
	# handles player knockback on damage
	# TODO: Tune to lurche at the start then slow instead of a linear bump
	# BUG: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	hitVector = (hurtbox.global_position - instance_from_id(hurtbox.hitboxTimers.keys()[-1]).global_position).normalized()
	# hitVector = Vector2.ZERO
	player.velocity.x = 140 * (hitVector.x)
	player.velocity.y = 120 * (hitVector.y) - 50
	freaky_timer.start()

### Reduces the player's velocity as it comes out of hitstun
func exit() -> void:
	stats.set_actionable(true)
	player.velocity.x *= 0.2

func update(_delta : float) -> void:
	pass
	
func physics_update(_delta : float) -> void:
	if Input.is_action_just_pressed("burst"):
		state_check()
	
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

func _on_stats_health_changed(diff: int) -> void:
	print(diff)
	if diff < 0:
		lastHitDmg = diff

func _on_freaky_timer_timeout() -> void:
	state_check()
