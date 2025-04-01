class_name Blast
extends PlayerState

@onready var projectileNode : Resource = preload("res://scenes/projectile.tscn")
@export var projectile : Projectile
@export var blastDir : float
@onready var locking : bool = false

func enter() -> void:
	player.velocity.x = 0
	player.velocity.y *= 0.2
	animation_player.play("blast")
	
	var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
	if direction.x > 0 or !animated_sprite.flip_h:
		animated_sprite.flip_h = false
		blastDir = 1.0
	elif direction.x < 0 or animated_sprite.flip_h:
		animated_sprite.flip_h = true
		blastDir = -1
	
	projectile = projectileNode.instantiate()
	projectile.create(player.global_position, blastDir, 5, 4)
	add_child(projectile)

func exit() -> void:
	pass

func update(_delta : float) -> void:
	pass

func physics_update(delta : float) -> void:		
	if !locking:
		var direction : Vector2 = Input.get_vector(
		"move_left", "move_right", "move_down", "move_up")
	
		if stats.actionable:
			player.velocity.x = direction.x * stats.SPEED
			if direction.x > 0:
				animated_sprite.flip_h = false
			elif direction.x < 0:
				animated_sprite.flip_h = true
		
		player.velocity.y = min(
			player.velocity.y + (stats.GRAVITY * delta), 
			stats.TERMINAL_VELOCITY)

func state_check() -> void:
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")

func lockPlayer() -> void:
	locking = true
	player.velocity.x = 0
	player.velocity.y *= 0.2
	
func unlockPlayer() -> void:
	locking = false
