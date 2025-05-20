class_name Zone
extends Node2D

signal zone_transitioned

# Zone killzone hitbox
@onready var killzone = $killzone

### Handles zone entry
func enter() -> void:
	pass
	
### Handles zone exit
func exit() -> void:
	pass
	
### Updates zone (non-physics) per tick
func update(_delta : float) -> void:
	pass
	
### Updates zone's physics per tick
func physics_update(_delta : float) -> void:
	pass

func disableMap() -> void:
	pass

func begin_transition() -> void:
	pass
