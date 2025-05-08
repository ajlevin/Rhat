class_name NemMelee
extends NemState

@onready var melee: Hitbox = $"../../Hitboxes/melee"

func _ready() -> void:
	melee.set_damage(1)
	melee.disable()

func enter() -> void:
	print("Nem Now Attacking")
	nemesis.velocity.x = 0
	animation_player.play("melee")
	
func exit() -> void:
	effect_sprite.play("blank")
	
func update(_delta : float) -> void:
	pass
	
func physics_update(delta : float) -> void:
	var direction : Vector2 = ndc.getPlayerDirection()
	var attackDirection : int = ndc.withinAttackRange()
	
	if attackDirection > 0:
		animated_sprite.flip_h = false
		melee.scale.x = 1
	elif attackDirection < 0:
		animated_sprite.flip_h = true
		melee.scale.x = -1
	else:
		melee.scale.x = -1 if animated_sprite.flip_h else 1
		
	effect_sprite.flip_h = animated_sprite.flip_h
	effect_sprite.position = Vector2(-20, 10) if animated_sprite.flip_h else Vector2(20, 10)
	
	# nemesis.velocity.x = direction.x * stats.SPEED
	nemesis.velocity.y = min(
		nemesis.velocity.y + (stats.GRAVITY * delta), 
		stats.TERMINAL_VELOCITY)

func state_check() -> void:
	if nemesis.is_on_floor():
		transitioned.emit(self, "nemidle")
	else:
		transitioned.emit(self, "nedmairborne")
