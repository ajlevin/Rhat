extends CharacterBody2D
class_name Player

func _ready():
	pass

func _process(_delta : float):
	pass

### Moves player based on currently set values each tick
func _physics_process(_delta : float):
	move_and_slide()
