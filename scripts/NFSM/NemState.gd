class_name NemState
extends Node

signal transitioned

@onready var nemesis : Nemesis = $"../.."
@onready var stats : NemStats = $"../../stats"
@onready var animated_sprite = $"../../AnimatedSprite"
@onready var effect_sprite: AnimatedSprite2D = $"../../EffectSprite"
@onready var animation_player = $"../../AnimationPlayer"
@onready var nav_agent: NavigationAgent2D = $"../../NavAgent"
@onready var ndc: NemDecisionController = $"../../NemDecisionController"

# Player rays for wall and ceiling detection
@onready var right_wall_ray : RayCast2D = $"../../Rays/rightWall"
@onready var left_wall_ray : RayCast2D = $"../../Rays/leftWall"
@onready var left_ray : RayCast2D = $"../../Rays/leftBump"
@onready var right_ray : RayCast2D = $"../../Rays/rightBump"
@onready var central_ray : RayCast2D = $"../../Rays/midBump"
@onready var player_tracker: RayCast2D = $"../../Rays/playerTracker"

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
