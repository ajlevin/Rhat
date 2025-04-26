class_name NemBurst
extends NemState
@onready var burst: Hitbox = $"../../Hitboxes/burst"

func _ready() -> void:
	burst.disable()
	burst.set_damage(1)

func enter() -> void:
	print("Nem Now Bursting")
	nemesis.velocity.x = 0
	nemesis.velocity.y = 0
	
	#if stats.burstCharges <= 0:
		#state_check()
	#else:
	stats.burstCharges -= 1
	burst.enable()
	animation_player.play("burst")
	
	var direction : Vector2 = ndc.getPlayerDirection()
	
	if direction.x > 0 or !animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif direction.x < 0 or animated_sprite.flip_h:
		animated_sprite.flip_h = true

func exit() -> void:
	burst.disable()

func update(_delta : float) -> void:
	pass

func physics_update(delta : float) -> void:		
	pass

func state_check() -> void:
	if nemesis.is_on_floor():
		transitioned.emit(self, "nemidle")
	else:
		transitioned.emit(self, "nemairborne")
