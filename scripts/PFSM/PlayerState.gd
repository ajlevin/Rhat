class_name PlayerState
extends Node

signal transitioned

@onready var player : Player = $"../.."
@onready var stats : PlayerStats = $"../../stats"
@onready var animated_sprite = $"../../AnimatedSprite"
@onready var effect_sprite: AnimatedSprite2D = $"../../EffectSprite"
@onready var animation_player = $"../../AnimationPlayer"

# Player rays for wall and ceiling detection
@onready var right_wall_ray : RayCast2D = $"../../Rays/rightWall"
@onready var left_wall_ray : RayCast2D = $"../../Rays/leftWall"
@onready var left_ray : RayCast2D = $"../../Rays/leftBump"
@onready var right_ray : RayCast2D = $"../../Rays/rightBump"
@onready var central_ray : RayCast2D = $"../../Rays/midBump"

### Handles state entry
func enter() -> void:
	pass
	
### Handles state exit
func exit() -> void:
	pass
	
### Updates state (non-physics) per tick
func update(_delta : float) -> void:
	pass
	
### Updates state's physics per tick
func physics_update(_delta : float) -> void:
	pass

func hitFreeze(timeScale : float, duration : float) -> void:
	Engine.time_scale = timeScale
	await(get_tree().create_timer(duration * timeScale).timeout)
	Engine.time_scale = 1.0
