extends RigidBody2D

var DIST = 1
var HEALTH = 2
var direction = -1
@onready var hitbox = $hitbox
@onready var stats = $stats
var damage = 1

### Set slime max health to 200
func _ready():
	stats.set_max_health(200)

### On death, remove from tree
func _on_health_zero():
	queue_free()

func _process(delta):
	pass

func _physics_process(delta):
	pass
