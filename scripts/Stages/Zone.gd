class_name Zone
extends Node2D

signal zone_transitioned

# Zone killzone hitbox
@onready var hitbox = $hitbox

### Handles zone entry
func enter():
	pass
	
### Handles zone exit
func exit():
	pass
	
### Updates zone (non-physics) per tick
func update(_delta : float):
	pass
	
### Updates zone's physics per tick
func physics_update(_delta : float):
	pass
