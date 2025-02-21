class_name Zone
extends Node2D

signal stage_transitioned
@onready var hitbox = $hitbox
const KILLZONE_DAMAGE = 99

func _ready():
	hitbox.set_damage(KILLZONE_DAMAGE)

func enter():
	pass
	
func exit():
	pass
	
func update(_delta : float):
	pass
	
func physics_update(_delta : float):
	pass
