class_name NemHit
extends NemState

@onready var hurtbox : Hurtbox = $"../../hurtbox"
@onready var freakier_timer: Timer = $"../../Timers/FreakierTimer"
var hitVector : Vector2

### Calculates the direction and force of knockback from the hit
func enter() -> void:
	print("Nem Now Hit")
	animation_player.play("iFrames")
	
	# handles player knockback on damage
	# ToDo: Tune to lurche at the start then slow instead of a linear bump
	hitVector = (hurtbox.global_position - instance_from_id(hurtbox.hitboxTimers.keys()[-1]).global_position).normalized()
	nemesis.velocity.x = 140 * (hitVector.x)
	nemesis.velocity.y = 120 * (hitVector.y) - 50
	freakier_timer.start()
	
### Reduces the player's velocity as it comes out of hitstun
func exit() -> void:
	nemesis.velocity.x *= 0.2
	
func update(_delta : float) -> void:
	pass
	
func physics_update(_delta : float) -> void:
	pass
	
### Checks for which state to put the player back into after hitstun
func state_check() -> void:
	var nInput = ndc.getCurInput()
	var direction : Vector2 = ndc.getPlayerDirection()
	
	match nInput:
		ndc.NemInput.Burst:
			transitioned.emit(self, "nemburst")
		_:
			if !nemesis.is_on_floor():
				transitioned.emit(self, "nemairborne")
			else:
				transitioned.emit(self, "nemidle")

func _on_freakier_timer_timeout() -> void:
	state_check()
