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
@onready var mood_timer: Timer = $"../Timers/MoodTimer"
@onready var nbm: NemBehaviorModel = $"../NemModel"

@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var log_file_path = "res://fastLogs/agrex_data" + \
	Time.get_datetime_string_from_system(true).replace(":", "").replace("-","") \
	+ ".txt" : get = getLogFilePath

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

const NemBehaviorEncodings : Dictionary = {
	"NemAirborne" : 0,
	"NemBlast" : 1,
	"NemBurst" : 2,
	"NemCounter" : 3,
	"NemDash" : 4,
	"NemDead" : 5,
	"NemHit" : 6,
	"NemIdle" : 7,
	"NemJump" : 8,
	"NemMelee" : 10,
	"NemOnWall" : 11,
	"NemRun" : 12
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
		
	print(log_file_path)

func getLastInput() -> NemInput:
	return lastInput

func setCurInput(newInput : NemInput) -> void:
	lastInput = curInput
	curInput = newInput

func getCurInput() -> NemInput:
	return curInput

func getCurInputString() -> String:
	return NemInput.keys()[curInput]

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

func getPlayerAggression() -> int:
	# return player.getPeriodAggression()
	return player.fetchCurAggression()

func getPastNemBehaviors() -> Array:
	return nemesis.getStateRecord()
	
func mapToNemBehaviorEncodings(behavior : String) -> int:
	return NemBehaviorEncodings.get(behavior)
	
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

func getLogFilePath() -> String:
	return log_file_path

func log_current_state():
	var file : FileAccess
	
	if FileAccess.file_exists(log_file_path):
		file = FileAccess.open(log_file_path, FileAccess.READ_WRITE)
		file.seek_end(0)
	else:
		file = FileAccess.open(log_file_path, FileAccess.WRITE_READ)
		file.store_csv_line(PackedStringArray([
			"playerAggression", 
			"distance", 
			"pastNemStates",
			"pastNemStatesENC",
			"nemInput",
			"curReward"]))

	var logEntry : PackedStringArray = PackedStringArray([
		getPlayerAggression(), # player aggression
		getPlayerDistance(), # distance
		# ",".join(PackedStringArray(getPastNemBehaviors())), # past nem states
		# getPastNemBehaviors().map(mapToNemBehaviorEncodings), # past nem states encoded numerically
		getCurInputString(), # current nem input
		getCurrentReward() # current nem reward value
	])
	# print(logEntry)
	file.store_csv_line(logEntry)
	file.close()

func _on_range_timer_timeout() -> void:
	print("yass")
	curTemperment.curRange = int(curTemperment.range * randf_range(0.5, 2))
	print(curTemperment.curRange)

func _on_mood_timer_timeout() -> void:
	curTemperment.moodChange.emit(curTemperment, nbm.calculateNextTemperment())
