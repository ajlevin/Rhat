class_name Temperment
extends Node

@onready var ndc: NemDecisionController = $"../../NemDecisionController"
@onready var nav_agent: NavigationAgent2D = $"../../NavAgent"
@onready var nemesis: Nemesis = $"../../."
@onready var player : Player = get_tree().get_first_node_in_group("Player")

# Value from 0.0 to 1.0 with 0.0 being easy and 1.0 being hard
# Determines the overall speed of the nemesis decision making
@export var fairness : float = 0.2
var dirToPlayer : Vector2 = Vector2.ZERO

signal moodChange

### Updates state (non-physics) per tick
func update(_delta : float) -> void:
	pass
	
### Updates state's physics per tick
func physics_update(_delta : float) -> void:
	pass
