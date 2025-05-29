extends Node

const NUM_BINS := 10
const MAX_HISTORY := 10

var q_table = {}

func _ready():
    load_q_table("res://model/q_table.json")  # Adjust path if needed

# Load the Q-table from the exported JSON
func load_q_table(path: String):
    if FileAccess.file_exists(path):
        var file = FileAccess.open(path, FileAccess.READ)
        var text = file.get_as_text()
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
    var simplified := []
    for val in past_behaviors.slice(-MAX_HISTORY, past_behaviors.size()):
        simplified.append(discretize_behavior(val))
    return str([player_agg, dist, simplified])

# Predict NemBehavior (0–100) using Q-table
func get_nem_behavior(player_agg: int, dist: int, past_behaviors: Array) -> int:
    var key := make_state_key(player_agg, dist, past_behaviors)
    if not q_table.has(key):
        return 50  # Default cautious behavior
    var q_values = q_table[key]
    var best_index = 0
    var best_value = -INF
    for i in range(q_values.size()):
        if q_values[i] > best_value:
            best_value = q_values[i]
            best_index = i
    return int(best_index * (100 / NUM_BINS))
