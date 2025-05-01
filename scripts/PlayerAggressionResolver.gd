class_name PlayerAggressionResolver
extends Resource

### TODO: Tune everything here
@export var aggressionMods : Dictionary = {
	"AirborneB" : -1.0,
	"AirborneF" : 1.0,
	"Blast" : -2.0,
	"Burst" : 5.0,
	"Counter" : -5.0,
	"DashB" : -3.0,
	"DashF" : 3.0,
	"Idle" : -1.0,
	"JumpB" : -1.0,
	"JumpF" : 2.0,
	"Melee" : 8.0,
	"OnWall" : -1.0,
	"RunB" : -2.0,
	"RunF" : 1.0
}

func getAgrressionModForState(stateString : String) -> float:
	if !aggressionMods.has(stateString):
		print("WARNING: Could not find " + stateString + " in aggressionMods")
	return aggressionMods.get(stateString, 0.0)
