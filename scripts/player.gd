extends CharacterBody2D
class_name Player

func _ready() -> void:
	print(self.global_position)

func _process(_delta : float) -> void:
	pass

### Moves player based on currently set values each tick
func _physics_process(_delta : float) -> void:
	move_and_slide()
