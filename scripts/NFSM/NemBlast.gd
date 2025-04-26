class_name NemBlast
extends NemState

@onready var projectileNode : Resource = preload("res://scenes/projectile.tscn")
@export var projectile : Projectile
@export var blastDir : float
@onready var locking : bool = false

func enter() -> void:
	print("Nem Now Blasting")
	nemesis.velocity.x = 0
	nemesis.velocity.y *= 0.2
	animation_player.play("blast")
	
	var direction : Vector2 = ndc.getPlayerDirection()
	
	if direction.x > 0 or !animated_sprite.flip_h:
		animated_sprite.flip_h = false
		blastDir = 1.0
	elif direction.x < 0 or animated_sprite.flip_h:
		animated_sprite.flip_h = true
		blastDir = -1
	
	projectile = projectileNode.instantiate()
	projectile.create(nemesis.global_position, blastDir, 5, 4)
	add_child(projectile)

func exit() -> void:
	pass

func update(_delta : float) -> void:
	pass

func physics_update(delta : float) -> void:		
	if !locking:
		var direction : Vector2 = Vector2.ZERO
	
		nemesis.velocity.x = direction.x * stats.SPEED
		if direction.x > 0:
			animated_sprite.flip_h = false
		elif direction.x < 0:
			animated_sprite.flip_h = true
		
		nemesis.velocity.y = min(
			nemesis.velocity.y + (stats.GRAVITY * delta), 
			stats.TERMINAL_VELOCITY)

func state_check() -> void:
	if nemesis.is_on_floor():
		transitioned.emit(self, "nemidle")
	else:
		transitioned.emit(self, "nemairborne")

func lockPlayer() -> void:
	locking = true
	nemesis.velocity.x = 0
	nemesis.velocity.y *= 0.2
	
func unlockPlayer() -> void:
	locking = false
