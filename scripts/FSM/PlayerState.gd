class_name PlayerState
extends Node

signal transitioned

@onready var player : Player = $"../.."
@onready var stats : Stats = $"../../stats"
@onready var animated_sprite = $"../../AnimatedSprite"
@onready var animation_player = $"../../AnimationPlayer"

@onready var right_wall_ray : RayCast2D = $"../../Rays/rightWall"
@onready var left_wall_ray : RayCast2D = $"../../Rays/leftWall"
@onready var left_ray : RayCast2D = $"../../Rays/leftBump"
@onready var right_ray : RayCast2D = $"../../Rays/rightBump"
@onready var central_ray : RayCast2D = $"../../Rays/midBump"

### Handles state entry
func enter():
	pass
	
### Handles state exit
func exit():
	pass
	
### Updates state (non-physics) per tick
func update(_delta : float):
	pass
	
### Updates state's physics per tick
func physics_update(_delta : float):
	pass
