class_name StageController
extends Node

@export var initialStage : Zone
@export var curStage : Zone
var stages : Dictionary = {}

func _ready():
	# Collects all states that exist as children within the tree
	for child in get_children():
		if child is Zone:
			pass
			# stages[child.name.to_lower()] = child
			# child.stage_transitioned.connect(on_stage_transition)
			
			
	# uses the initialState if exists, otherwises defaults to "spawn"
	#if initialStage:
		#initialStage.enter()
		#curStage = initialStage
	#else:
		#stages["intro"].enter()
		#curStage = stages["intro"]
	
### Updates current stage
func _process(delta):
	if curStage:
		curStage.update(delta)
		
### Updates current stage's physics
func _physics_process(delta):
	if curStage:
		curStage.physics_update(delta)
	
### Handles transitions from one stage to the next
func on_stage_transition(stage, newStageName):
	# reached if an inactive stage manages to emit a signal >:(
	if stage != curStage:
		return
	
	var newStage = stages.get(newStageName.to_lower())
	# reached if the requested stage doesn't exist (check stage spelling)
	if !newStage:
		return
	
	# handle current stage exit
	if curStage:
		curStage.exit()
		
	# handle new stage entry and update current stage
	newStage.enter()
	curStage = newStage
