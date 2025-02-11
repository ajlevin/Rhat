class_name Zone
extends Node2D

@onready var hitbox = $hitbox
const DAMAGE = 99

func _ready():
	hitbox.set_damage(DAMAGE)
