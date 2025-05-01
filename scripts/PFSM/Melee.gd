class_name Melee
extends PlayerState

@onready var melee: Hitbox = $"../../Hitboxes/melee"

func _ready() -> void:
	melee.set_damage(1)
	melee.disable()

func enter() -> void:
	animation_player.play("melee")
	
func exit() -> void:
	effect_sprite.play("blank")
	
func update(_delta : float) -> void:
	pass
	
func physics_update(delta : float) -> void:
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	if direction.x > 0:
		animated_sprite.flip_h = false
		melee.scale.x = 1
	elif direction.x < 0:
		animated_sprite.flip_h = true
		melee.scale.x = -1
	else:
		melee.scale.x = -1 if animated_sprite.flip_h else 1
	
	effect_sprite.flip_h = animated_sprite.flip_h
	effect_sprite.position = Vector2(-20, 10) if animated_sprite.flip_h else Vector2(20, 10)
	
	if stats.actionable:
		player.velocity.x = direction.x * stats.SPEED
	player.velocity.y = min(
		player.velocity.y + (stats.GRAVITY * delta), 
		stats.TERMINAL_VELOCITY)

func state_check() -> void:
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")
