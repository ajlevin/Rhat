class_name PlayerState
extends Node

signal transitioned

@onready var player : Player = $"../.."
@onready var right_wall_ray : RayCast2D = $"../../Rays/rightWallRay"
@onready var left_wall_ray : RayCast2D = $"../../Rays/leftWallRay"
@onready var left_ray : RayCast2D = $"../../Rays/leftRay"
@onready var right_ray : RayCast2D = $"../../Rays/rightRay"
@onready var central_ray : RayCast2D = $"../../Rays/centralRay"
@onready var stats : Stats = $"../../stats"
@onready var animation_player = $"../../AnimationPlayer"

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
