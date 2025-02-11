extends RigidBody2D

var DIST = 1
var HEALTH = 2
var direction = -1
@onready var hitbox = $hitbox
@onready var stats = $stats
var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	stats.set_max_health(2)

func _on_health_zero():
	queue_free()

func _process(delta):
	pass

func _physics_process(delta):
	pass
