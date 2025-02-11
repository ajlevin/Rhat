class_name Hurtbox
extends Area2D

signal damaged(damage: int)
## @export var health: Health ??????
## !! health must always be on the same level as the hurtbox/hitbox !!
@onready var stats : Stats = $"../stats"
@export var hitboxes : Array[Hitbox] = []

func _process(delta):
	for hitbox in hitboxes:
		pass

func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox != null:
		hitboxes.append(hitbox)
		stats.health -= hitbox.damage
		damaged.emit(hitbox.damage)
		

func _on_area_exited(hitbox: Hitbox):
	if hitbox != null:
		hitboxes.erase(hitbox)
