class_name Hitbox
extends Area2D

@export var damage : int = 1 : set = set_damage, get = get_damage
@onready var shape : CollisionShape2D = get_children()[0]

### Sets the hitbox's damage
func set_damage(value: int) -> void:
	damage = value
	
### Returns the hitbox's damage
func get_damage() -> int:
	return damage

func disable() -> void:
	shape.disabled = true

func enable() -> void:
	shape.disabled = false
