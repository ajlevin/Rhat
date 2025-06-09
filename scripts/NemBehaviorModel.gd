class_name  NemBehaviorModel
extends Node

const NUM_BINS : int = 10
const MAX_HISTORY : int = 10

@onready var ndc: NemDecisionController = $"../NemDecisionController"
var q_table : Dictionary = {}

func _ready() -> void:
	load_q_table("res://model/q_table.json")  # Adjust path if needed

# Load the Q-table from the exported JSON
func load_q_table(path: String):
	if FileAccess.file_exists(path):
		var file : FileAccess = FileAccess.open(path, FileAccess.READ)
		var text : String = file.get_as_text()
		q_table = JSON.parse_string(text)
		file.close()
		print("Q-table loaded.")
	else:
		push_error("Could not find q_table.json at path: " + path)

# Discretize behavior value into bin index (0 to NUM_BINS-1)
func discretize_behavior(value: int) -> int:
	return clamp(int(floor(value / (100.0 / NUM_BINS))), 0, NUM_BINS - 1)

# Convert current game state into a Q-table key string
func make_state_key(player_agg: int, dist: int, past_behaviors: Array) -> String:
	var simplified : Array = []
	for val in past_behaviors.slice(-MAX_HISTORY, past_behaviors.size()):
		simplified.append(discretize_behavior(val))
	return str([player_agg, dist, simplified])

# Predict NemBehavior (0–100) using Q-table
func get_nem_behavior(player_agg: int, dist: int, past_behaviors: Array) -> int:
	var key : String = make_state_key(player_agg, dist, past_behaviors)
	if not q_table.has(key):
		return -1  # Missing entry
	var q_values : Array = q_table[key]
	var best_index : int = 0
	var best_value : int = -INF
	for i in range(q_values.size()):
		if q_values[i] > best_value:
			best_value = q_values[i]
			best_index = i
	return int(best_index * (100 / NUM_BINS))

### PROOF OF CONCEPT:
func calculateNextTemperment() -> String:
	var nemBehavior : int = get_nem_behavior( \
		ndc.getPlayerAggression(), ndc.getPlayerDistance(), ndc.getPastNemBehaviors())
	nemBehavior = nemBehavior if nemBehavior > 0 else ndc.getPlayerAggression()
	
	if ndc.getPlayerAggression() < 15:
		return "risky"
	elif ndc.getPlayerAggression() < 37:
		return "brave"
	elif ndc.getPlayerAggression() < 63:
		return "neutral"
	elif ndc.getPlayerAggression() < 85:
		return "reserved"
	else:
		return "cowardly"
