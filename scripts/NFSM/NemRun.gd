class_name NemRun
extends NemState

func enter() -> void:
	print("Nem Now Running")
	nemesis.velocity.y = 0
	stats.extraJump = true
	
	###! This doesn't fully work either as it should update when that ends !###
	if !animation_player.current_animation == "iFrames":
		animation_player.play("run")
	
func exit() -> void:
	pass
	
func update(_delta : float) -> void:
	pass
	
### Gets directional input and adjusts horizantal velocity accordingly
func physics_update(_delta : float) -> void:
	var direction : Vector2 = ndc.getPlayerDirection()

	nemesis.velocity.x = direction.x * stats.SPEED
	
	if (direction.x > 0):
		animated_sprite.flip_h = false
	elif (direction.x < 0):
		animated_sprite.flip_h = true
	state_check(direction)
	
### Checks if the player has left the ground or stopped moving
func state_check(direction : Vector2) -> void:	
	if ndc.withinAttackRange() != 0:
		transitioned.emit(self, "nemmelee")
	elif !direction.x:
		transitioned.emit(self, "nemidle")
	#elif Input.is_action_just_pressed("dash") and stats.get_dash() and stats.get_actionable():
		#transitioned.emit(self, "dash")
	elif direction.y < -0.5:
		transitioned.emit(self, "nemjump")
	elif !nemesis.is_on_floor():
		transitioned.emit(self, "nemairborne")
	#elif Input.is_action_just_pressed("special") and stats.get_actionable():
		#transitioned.emit(self, "blast")
