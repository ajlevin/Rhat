class_name Counter
extends PlayerState

@onready var hurtbox: Hurtbox = $"../../hurtbox"
var counterDir : float

func _ready() -> void:
	pass

func enter() -> void:
	player.velocity.x *= 0.2
	player.velocity.y *= 0.2
	animation_player.play("counter")
	
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	if direction.x > 0 or !animated_sprite.flip_h:
		animated_sprite.flip_h = false
		counterDir = 1.0
	elif direction.x < 0 or animated_sprite.flip_h:
		animated_sprite.flip_h = true
		counterDir = -1

func exit() -> void:
	pass

func update(_delta : float) -> void:
	pass

func physics_update(delta : float) -> void:		
	player.velocity.y = min(
		player.velocity.y + (stats.GRAVITY * delta * 0.4), 
		stats.TERMINAL_VELOCITY * 0.4)

func _on_hurtbox_area_entered(hitbox: Hitbox) -> void:
	var projectile : Projectile
	
	if hitbox.get_parent() is Projectile:
		projectile = hitbox.get_parent()
		if stats.countering:
			print("NOM")
			projectile.reverse(true)
			disableCounter()
			state_check()

func enableCounter() -> void:
	# set visual
	stats.set_immortality(true)
	stats.countering = true
	
func disableCounter() -> void:
	# disable visual
	stats.set_immortality(false)
	# AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	# stats.countering = false

func state_check() -> void:
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")
