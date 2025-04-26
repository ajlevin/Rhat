class_name Player
extends CharacterBody2D

@onready var stats: PlayerStats = $stats
@onready var state_machine: PlayerStateMachine = $StateMachine

func _ready() -> void:
	pass

func _process(_delta : float) -> void:
	pass

### Moves player based on currently set values each tick
func _physics_process(_delta : float) -> void:
	stats.recharge_burst()
	move_and_slide()

### Fetch current player state (used for nemFSM)
func getCurPlayerState() -> PlayerState:
	return state_machine.curState
