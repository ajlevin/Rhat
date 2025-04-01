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
@onready var player : Player = get_tree().get_first_node_in_group("Player")

enum NemInput {
	None,
	Idle,
	Dash,
	Melee,
	Blast,
	Counter,
	Left,
	Right,
	Jump
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

func withinBlastRange() -> int:
	return 0

func getPlayerDirection() -> Vector2:
	return nemesis.global_position.direction_to(nav_agent.get_next_path_position())

### Handles transitions from one temperment to the next
func on_mood_change(temperment, newTempermentName) -> void:
	# reached if an inactive state manages to emit a signal >:(
	if temperment != curTemperment:
		return
	
	var newTemperment = temperments.get(newTempermentName.to_lower())
	if newTemperment:
		curTemperment = newTemperment

func _process(delta : float) -> void:
	curTemperment.update(delta)

func _physics_process(delta : float) -> void:
	curTemperment.physics_update(delta)
