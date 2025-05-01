class_name Burst
extends PlayerState

@onready var burst: Hitbox = $"../../Hitboxes/burst"

func _ready() -> void:
	burst.disable()

func enter() -> void:
	player.velocity.x = 0
	player.velocity.y = 0
	stats.burstCharges -= 1
	burst.enable()
	burst.set_damage(1)
	animation_player.play("burst")
	
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	if direction.x > 0 or !animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif direction.x < 0 or animated_sprite.flip_h:
		animated_sprite.flip_h = true
		
	effect_sprite.flip_h = animated_sprite.flip_h
	effect_sprite.position = Vector2(0, 0)

func exit() -> void:
	effect_sprite.play("blank")
	burst.disable()

func update(_delta : float) -> void:
	pass

func physics_update(delta : float) -> void:		
	pass

func state_check() -> void:
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")
