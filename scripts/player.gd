class_name Player
extends CharacterBody2D

func _ready() -> void:
	pass

func _process(_delta : float) -> void:
	pass

### Moves player based on currently set values each tick
func _physics_process(_delta : float) -> void:
	move_and_slide()
