import json

NUM_BINS = 10
MAX_HISTORY = 10

# --- Load the Q-table ---
def load_model(filepath="q_table.json"):
    with open(filepath, "r") as f:
        q_table = json.load(f)
    return q_table

# --- Helper functions ---
def discretize_behavior(val: int) -> int:
    return min(NUM_BINS - 1, max(0, val // (100 // NUM_BINS)))

def make_state_key(player_agg: int, dist: int, past: list[int]) -> str:
    simplified = tuple(discretize_behavior(b) for b in past[-MAX_HISTORY:])
    return str((player_agg, dist, simplified))

# --- Predict next NemBehavior ---
def predict_behavior(q_table, player_agg, dist, past_behaviors):
    key = make_state_key(player_agg, dist, past_behaviors)
    if key not in q_table:
        return 50  # Default cautious behavior
    q_values = q_table[key]
    best_action = max(range(NUM_BINS), key=lambda i: q_values[i])
    return best_action * (100 // NUM_BINS)

# --- Example Use ---
if __name__ == "__main__":
    model = load_model()

    player_agg = 7
    dist = 4
    past = [30, 40, 60, 10, 0, 20, 30, 40, 70, 80]

    predicted = predict_behavior(model, player_agg, dist, past)
    print("Predicted NemBehavior:", predicted)
