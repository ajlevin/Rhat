class_name Nemesis
extends CharacterBody2D

const SHADER = preload("res://scripts/player.gdshader")
const STATE_RECORD_COUNT = 60

signal nemDied

@onready var player_tracker: RayCast2D = $Rays/playerTracker
@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var stats: NemStats = $stats
@onready var nsm: NemStateMachine = $NemStateMachine
@onready var ndc: NemDecisionController = $NemDecisionController
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var periodDamage : int = 0 : get = getPeriodDamage, set = setPeriodDamage
@onready var stateRecord : Array = [] : get = getStateRecord

func _ready() -> void:
	nav_agent.path_desired_distance = 40
	nav_agent.target_desired_distance = 40
	nav_agent.simplify_path = false
	actor_setup.call_deferred()	

func actor_setup():
	await get_tree().physics_frame
	nav_agent.target_position = player.global_position

### Update raycast tracking player location and distance
func _process(delta: float) -> void:
	player_tracker.target_position = global_position.direction_to(player.global_position) * 30

### Moves nemesis based on currently set values each tick
func _physics_process(_delta : float) -> void:
	# nav_agent.get_next_path_position()
	move_and_slide()

func getPeriodDamage() -> int:
	return periodDamage

func setPeriodDamage(val : int) -> void:
	periodDamage = val

func getPeriodReward() -> int:
	return player.getPeriodDamage() - getPeriodDamage()

func getStateRecord() -> Array:
	return stateRecord

func getStateRecordEncodings() -> Array:
	return stateRecord

func updateStateRecord(newState : NemState) -> void:
	if len(stateRecord) >= STATE_RECORD_COUNT:
		stateRecord.pop_front()
	stateRecord.push_back(newState.name)

func getPlayerAggression() -> float:
	return player.getPeriodAggression()

func _on_hurtbox_damaged(damage: int) -> void:
	periodDamage += damage

func _on_log_timer_timeout() -> void:
	print(stateRecord)
	ndc.log_current_state()

func reviveNem() -> void:
	animation_player.play("RESET")
	nsm.revive()
