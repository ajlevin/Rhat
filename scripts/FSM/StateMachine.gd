class_name StateMachine
extends Node

@export var initialState : State
var curState : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
			
	if initialState:
		initialState.enter()
		curState = initialState

func _process(delta):
	if curState:
		curState.update(delta)
		
func _physics_process(delta):
	if curState:
		curState.physics_update(delta)

func on_child_transition(state, newStateName):
	# reached if an inactive state manages to emit a signal >:(
	if state != curState:
		return
	
	var newState = states.get(newStateName.to_lower())
	# reached if the requested state doesn't exist (check state spelling)
	if !newState:
		return
		
	if curState:
		curState.exit()
		
	newState.enter()
	curState = newState
