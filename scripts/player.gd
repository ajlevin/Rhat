class_name Player
extends CharacterBody2D

@onready var stats: PlayerStats = $stats
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var periodDamage = 0 : get = getPeriodDamage, set = setPeriodDamage
@onready var periodAggression = 50.0 : get = getPeriodAggression, set = setPeriodAggression
@onready var nemesis : Nemesis = get_tree().get_first_node_in_group("Nemesis")
var aggressionMods = preload("res://scripts/playerAggressionResolver.tres")

func _ready() -> void:
	pass

func _process(_delta : float) -> void:
	# TODO: tune aggression
	# attenuated rolling avg?? 
	# factor in distance? 
	# ratio between moves?
	#     check for counts?
	# maybe add additional count array to show buckets of frequency
	periodAggression += fetchCurAggression()

### Moves player based on currently set values each tick
func _physics_process(_delta : float) -> void:
	stats.recharge_burst()
	move_and_slide()

### Fetch current player state (used for nemFSM)
func getCurPlayerState() -> PlayerState:
	return state_machine.curState

func getPeriodDamage() -> int:
	return periodDamage
	
func setPeriodDamage(val : int) -> void:
	periodDamage = val

func _on_hurtbox_damaged(damage: int) -> void:
	periodDamage += damage

func getPeriodAggression() -> float:
	return periodAggression

func setPeriodAggression(val : float) -> void:
	periodAggression = clampf(val, 0.0, 100.0)

func fetchCurAggression() -> float:
	var directionalStates = ["Airborne", "Dash", "Jump", "Run"]
	var curStateName : String = state_machine.curState.name
	var forward : bool = isMovingTowardsNem()
	
	if nemesis == null:
		nemesis = get_tree().get_first_node_in_group("Nemesis")
		if nemesis == null: 
			return 0.0
	
	if directionalStates.has(curStateName):
		curStateName += "F" if forward else "B"
	return aggressionMods.getAgrressionModForState(curStateName)

func isMovingTowardsNem() -> bool:
	if nemesis != null:
		return global_position.direction_to(nemesis.global_position).normalized().dot(velocity.normalized()) > -0.4
	return false
