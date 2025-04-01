class_name NemBlast
extends NemState

@onready var blast : Hitbox = $"../../Hitboxes/blast"
var blastDir : float

func _ready() -> void:
	blast.set_damage(2)
	blast.disable()

func enter() -> void:
	print("Now Blasting")
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
	
	blast.global_position = nemesis.global_position + Vector2(blastDir * 10, 0)

func exit() -> void:
	pass

func update(_delta : float) -> void:
	pass

func physics_update(delta : float) -> void:		
	nemesis.velocity.y = min(
		nemesis.velocity.y + (stats.GRAVITY * delta * 0.4), 
		stats.TERMINAL_VELOCITY * 0.4)
	
	blast.global_position.x += blastDir * 12

func _on_blast_area_entered(area: Area2D) -> void:
	blast.disable()

func state_check() -> void:
	if nemesis.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")
