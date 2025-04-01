class_name Slime
extends RigidBody2D

var health : int = 2
@onready var hitbox : Hitbox = $hitbox
@onready var stats : CreatureStats = $stats
var damage : int = 1

### Set slime max health to 5
func _ready() -> void:
	stats.set_max_health(5)
	hitbox.set_damage(1)

### On death, remove from tree
func _on_health_zero() -> void:
	print("ouchie")
	queue_free()

func _process(delta) -> void:
	pass

func _physics_process(delta) -> void:
	pass
