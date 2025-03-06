class_name StateMachine
extends Node

@export var initialState : PlayerState
var curState : PlayerState
var states : Dictionary = {}

### Collect all existing states and set initial state
func _ready() -> void:
	# Collects all states that exist as children within the tree
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
			
	# uses the initialState if exists, otherwises defaults to "spawn"
	if initialState:
		initialState.enter()
		curState = initialState
	else:
		states["spawn"].enter()
		curState = states["spawn"]

### Updates current state
func _process(delta) -> void:
	if curState:
		curState.update(delta)
		
### Updates current state's physics
func _physics_process(delta) -> void:
	if curState:
		curState.physics_update(delta)

### Handles transitions from one state to the next
func on_child_transition(state, newStateName) -> void:
	# reached if an inactive state manages to emit a signal >:(
	if state != curState:
		return
	
	var newState = states.get(newStateName.to_lower())
	# reached if the requested state doesn't exist (check state spelling)
	if !newState:
		return
	
	# handle current state exit
	if curState:
		curState.exit()
		
	# handle new state entry and update current state
	newState.enter()
	curState = newState

### Waits for player death signal and switches to "dead" state
func _on_health_zero() -> void:
	print("Got death signal")
	on_child_transition(curState, "dead")

### Waits for player damaged and switches to "hit" state
func _on_health_changed(diff) -> void:
	if diff < 0:
		on_child_transition(curState, "hit")
