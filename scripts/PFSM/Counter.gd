class_name Counter
extends PlayerState

@onready var counter: Area2D = $"../../counter"
@onready var counter_shape: CollisionShape2D = $"../../counter/counterShape"
var counterDir : float

func _ready() -> void:
	counter_shape.disabled = true

func enter() -> void:
	player.velocity.x *= 0.4
	player.velocity.y *= 0.2
	animation_player.play("counter")
	
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	if direction.x > 0 or !animated_sprite.flip_h:
		animated_sprite.flip_h = false
		counterDir = 1.0
		counter.scale.x = 1
	elif direction.x < 0 or animated_sprite.flip_h:
		animated_sprite.flip_h = true
		counterDir = -1
		counter.scale.x = -1
		
	effect_sprite.flip_h = animated_sprite.flip_h
	effect_sprite.rotation = 9 if animated_sprite.flip_h else 10
	effect_sprite.position = Vector2(-20, 0) if animated_sprite.flip_h else Vector2(20, 0)

func exit() -> void:
	pass

func update(_delta : float) -> void:
	pass

func physics_update(delta : float) -> void:		
	player.velocity.y = min(
		player.velocity.y + (stats.GRAVITY * delta * 0.4), 
		stats.TERMINAL_VELOCITY * 0.4)
		
	if player.is_on_floor():
		player.velocity.x = 0

func _on_counter_area_entered(hitbox: Hitbox) -> void:
	var projectile : Projectile
	
	if hitbox.get_parent() is Projectile:
		projectile = hitbox.get_parent()
		if stats.countering:
			projectile.reverse(true)
			disableCounter()
			state_check()

func enableCounter() -> void:
	# set visual
	stats.set_immortality(true)
	stats.countering = true
	counter_shape.disabled = false

func disableCounter() -> void:
	# disable visual
	effect_sprite.rotation = 0
	effect_sprite.play("blank")
	stats.set_immortality(false)
	stats.countering = false
	counter_shape.disabled = true

func state_check() -> void:
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")
