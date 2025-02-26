class_name Hitbox
extends Area2D

@export var damage: int = 1 : set = set_damage, get = get_damage

### Sets the hitbox's damage
func set_damage(value: int):
	damage = value
	
### Returns the hitbox's damage
func get_damage() -> int:
	return damage
