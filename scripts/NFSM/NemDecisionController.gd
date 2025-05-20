class_name NemDecisionController
extends Node

@onready var nemesis: Nemesis = $".."
@onready var stats: NemStats = $"../stats"
@onready var nfsm: NemStateMachine = $"../NemStateMachine"
@onready var nav_agent: NavigationAgent2D = $"../NavAgent"
@onready var player_tracker: RayCast2D = $"../Rays/playerTracker"
@onready var down_left: RayCast2D = $"../Rays/downLeft"
@onready var down_right: RayCast2D = $"../Rays/downRight"
@onready var down: RayCast2D = $"../Rays/down"
@onready var ceiling: RayCast2D = $"../Rays/ceiling"

@onready var player : Player = get_tree().get_first_node_in_group("Player")
@export var log_file_path = "user://stage_data.csv"

@export var targetDir : Vector2
enum NemInput {
	None,
	Idle,
	Dash,
	Melee,
	Blast,
	Counter,
	Run,
	Jump,
	Burst
}

@export var initialTemperment : Temperment
@export var curTemperment : Temperment
var temperments : Dictionary = {}

@onready var lastInput : NemInput = NemInput.Idle : get = getLastInput
@onready var curInput : NemInput = NemInput.Idle : get = getCurInput, set = setCurInput

### Collect all existing temperments and set initial temperment
func _ready() -> void:
	# Collects all states that exist as children within the tree
	for child in get_children():
		if child is Temperment:
			temperments[child.name.to_lower()] = child
			child.moodChange.connect(on_mood_change)
			
	# uses the initialState if exists, otherwises defaults to "spawn"
	if initialTemperment:
		curTemperment = initialTemperment
	else:
		curTemperment = temperments["neutral"]

func getLastInput() -> NemInput:
	return lastInput

func setCurInput(newInput : NemInput) -> void:
	lastInput = curInput
	curInput = newInput

func getCurInput() -> NemInput:
	return curInput

func withinAttackRange() -> int:	
	if player_tracker.is_colliding():
		return -1 if \
			(player_tracker.target_position - player_tracker.position).x < 0 \
			else 1
	else: 
		return 0

func withinBlastRange() -> bool:
	return abs(player.global_position.y - nemesis.global_position.y) < 80

func incomingBlast() -> Vector2:
	var blast : Projectile = get_tree().get_first_node_in_group("projectile")
	if blast != null and blast.isPlayerOwned():
		return nemesis.global_position.direction_to(blast.global_position)
	return Vector2.ZERO
	
func playerApproaching() -> bool:
	return getPlayerDirection().normalized().dot(player.velocity.normalized()) < -0.6
	
func playerIsGrounded() -> bool:
	return abs(player.global_position).distance_to(nemesis.global_position) > 100 \
		or player.getCurPlayerState() is Idle \
		or player.getCurPlayerState() is Run

func getPlayerDirection() -> Vector2:
	return nemesis.global_position.direction_to(nav_agent.get_next_path_position())

func getPlayerDistance() -> float:
	return nemesis.global_position.dot(player.global_position)

func getPastNemBehaviors() -> Array:
	return nemesis.getStateRecord()
	
func getCurrentReward() -> int:
	return nemesis.getPeriodReward()

func requiresJump() -> bool:
	return !ceiling.is_colliding() \
		and (getPlayerDirection().normalized().y < -0.3 or playerOnUpperPlatform()) \
		and ((nemesis.velocity.y >= 0 and stats.extraJump) or nemesis.is_on_floor())

func maintainJump() -> bool:
	return (getPlayerDirection().normalized().y < -0.3 or playerOnUpperPlatform()) and nemesis.velocity.y <= 0

func playerOnUpperPlatform() -> bool:
	return player.is_on_floor() and getPlayerDirection().normalized().y < 0

### Handles transitions from one temperment to the next
func on_mood_change(temperment, newTempermentName) -> void:
	# reached if an inactive state manages to emit a signal >:(
	if temperment != curTemperment:
		return
	
	var newTemperment = temperments.get(newTempermentName.to_lower())
	if newTemperment:
		curTemperment = newTemperment

func _process(delta : float) -> void:
	nemesis.updateStateRecord(nfsm.curState)
	curTemperment.update(delta)

func _physics_process(delta : float) -> void:
	curTemperment.physics_update(delta)
	log_current_state()

func log_current_state():
	#var file = File.new()
	#if !file.exists(log_file_path):
		#file.open(log_file_path, File.WRITE)
		#file.store_string("player_aggression,distance_to_enemy,past_behaviors,action,reward\n")
	#else:
		#file.open(log_file_path, File.APPEND)

	# Normalize inputs
	#var normalized_distance = distance_to_enemy / MAX_DISTANCE  # Replace MAX_DISTANCE with actual max
	#var normalized_player_aggression = player_aggression / 100.0  # 0-100 → 0-1
#
	## Encode past behaviors as a string (e.g., "0,1,0,0,2,...")
	#var past_behavior_str = ""
	#for behavior in past_nem_behaviors:
		#past_behavior_str += str(behavior) + ","
#
	## Current action (aggression level) and reward (from damage metric)
	#var current_action = aggression_level
	#var current_reward = get_current_reward()  # Implement this function to track damage
#
	#file.store_string("%s, %s, %s, %s, %s \n" % \
		#[normalized_player_aggression, \
		#normalized_distance, \
		#past_behavior_str, \
		#current_action, \
		#current_reward])
	#file.close()
	pass

#func get_current_reward() -> int:
	#return 0
