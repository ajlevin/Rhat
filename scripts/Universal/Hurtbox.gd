class_name Hurtbox
extends Area2D

signal damaged(damage: int)
## !! stats must always be on the same level as the hurtbox/hitbox !!
@onready var stats : Stats = $"../stats"
@export var hitboxes : Array[Hitbox] = []

#######################################################################
###! Documentation will be updated once damage ticks actually work !###
#######################################################################

func _process(delta):
	for hitbox in hitboxes:
		# need damage to tick when the player is in contact with enemy
		# but not when attacks pass through enemies 
		pass

func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox != null:
		hitboxes.append(hitbox)
		print("entered " + hitbox.get_parent().name)
		
		stats.health -= hitbox.damage
		damaged.emit(hitbox.damage)

func _on_area_exited(hitbox: Hitbox):
	if hitbox != null:
		hitboxes.erase(hitbox)
		print("left " + hitbox.get_parent().name)
