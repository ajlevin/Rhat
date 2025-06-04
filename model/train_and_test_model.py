import os
import csv
import json

# === Config ===
NUM_DISTANCE_BINS = 3
NUM_PLAYER_BINS = 5
NUM_ACTIONS = 13
LEARNING_RATE = 0.3
DISCOUNT = 0.9
NUM_EPOCHS = 10
PLAYER_AGG_MAX = 100
DISTANCE_MAX = 500000 

q_table = {}

# === Action Mapping ===
action_mapping = {
    "Airborne": 0,
    "Blast": 1,
    "Burst": 2,
    "Counter": 3,
    "Dash": 4,
    "Dead": 5,
    "Hit": 6,
    "Idle": 7,
    "Jump": 8,
    "Melee": 10,
    "OnWall": 11,
    "Run": 12
}
reverse_action_mapping = {v: k for k, v in action_mapping.items()}

# === Aggression Mapping (action: aggression_level from 0-100) ===
aggression_mapping = {
    "Airborne": 50,
    "Blast": 60,
    "Burst": 80,
    "Counter": 0,
    "Dash": 50,
    "Dead": 50,
    "Hit": 50,
    "Idle": 30,
    "Jump": 50,
    "Melee": 100,
    "OnWall": 30,
    "Run": 50
}

# === Helper Functions ===

def decode_nem_state(nem_state: str) -> int:
    key = nem_state.replace("Nem", "")
    return action_mapping.get(key, 1)  # default to Idle if not found

def discretize_value(value: float, max_value: float, num_bins: int) -> int:
    """Discretize any value into an integer bin."""
    bin_width = max_value / num_bins
    return min(num_bins, max(0, int(value // bin_width)))

def make_state(player_agg: float, dist: float) -> tuple:
    player_agg_bin = discretize_value(player_agg, PLAYER_AGG_MAX, NUM_PLAYER_BINS)
    dist_bin = discretize_value(dist, DISTANCE_MAX, NUM_DISTANCE_BINS)
    return (player_agg_bin, dist_bin)

def choose_action(state: tuple) -> int:
    if state not in q_table:
        q_table[state] = [0.0] * NUM_ACTIONS
    return max(range(NUM_ACTIONS + 1), key=lambda i: q_table[state][i])

def update_q(state: tuple, action: int, reward: int, next_state: tuple):
    if next_state not in q_table:
        q_table[next_state] = [0.0] * NUM_ACTIONS
    current_q = q_table[state][action]
    max_future_q = max(q_table[next_state])
    q_table[state][action] += LEARNING_RATE * (reward + DISCOUNT * max_future_q - current_q)

# === Training ===

def train_step(player_agg: float, dist: float, nem_behavior: int, reward: int):
    state = make_state(player_agg, dist)
    action = nem_behavior
    next_state = state
    update_q(state, action, reward, next_state)

def load_and_train_from_logs(log_folder: str):
    files = [f for f in os.listdir(log_folder) if f.endswith(".txt")]
    for epoch in range(NUM_EPOCHS):
        print(f"Epoch {epoch+1}/{NUM_EPOCHS}")
        for filename in files:
            # print(f"Processing file: {filename}") # Debugging
            filepath = os.path.join(log_folder, filename)
            with open(filepath, "r", newline='', encoding='utf-8') as txtfile:
                reader = csv.DictReader(txtfile)
                for row in reader:
                    try:
                        player_agg = float(row["playerAggression"])
                        dist = float(row["distance"])
                        nem_behavior_str = row["nemInput"]
                        nem_behavior = decode_nem_state(nem_behavior_str)
                        raw_reward = float(row["curReward"])
                        reward = -1 if raw_reward < 0 else (1 if raw_reward > 0 else 0)
                        # print(f"Player Aggression: {player_agg}, Distance: {dist}, NemBehavior: {nem_behavior}, Reward: {reward}") # Debugging
                        train_step(player_agg, dist, nem_behavior, reward)
                    except Exception as e:
                        print(f"Error processing row in {filename}: {e}")

def save_model(filename="q_table.json"):
    with open(filename, "w") as f:
        json.dump({str(k): v for k, v in q_table.items()}, f, indent=2)

# === Prediction ===

def load_q_table(filename="q_table.json"):
    with open(filename, "r") as f:
        return json.load(f)

def predict_nem_behavior(q_table, player_agg: float, dist: float) -> int:
    state = str(make_state(player_agg, dist))
    if state not in q_table:
        return "Idle"  # default
    q_values = q_table[state]
    best_action_index = max(range(NUM_ACTIONS), key=lambda i: q_values[i])
    nem_behavior_label = reverse_action_mapping[best_action_index]
    return nem_behavior_label

def get_weighted_aggression(q_table, player_agg: float, dist: float) -> float:
    state = str(make_state(player_agg, dist))
    if state not in q_table:
        return 50  # Default aggression if state unseen

    q_values = q_table[state]
    weighted_sum = 0.0
    total_weight = 0.0

    for action_index, q_value in enumerate(q_values):
        if action_index not in reverse_action_mapping:
            continue  # skip invalid indices
        behavior_label = reverse_action_mapping[action_index]
        aggression_level = aggression_mapping.get(behavior_label, 50)
        weight = 1 + q_value
        weighted_sum += weight * aggression_level
        total_weight += weight

    if total_weight == 0:
        return 50  # fallback
    net_aggression = weighted_sum / total_weight
    print(f"Weighted Aggression for state {state}: {net_aggression:.2f}") # Debugging
    return net_aggression

# === Main ===

if __name__ == "__main__":
    print("Training model from logs...")
    load_and_train_from_logs("../logs")
    print("Training complete.")

    print("Training model from fastlogs...")
    load_and_train_from_logs("../fastlogs")
    print("Training complete.")

    save_model()
    print("Model saved to q_table.json.")

    # Example test prediction
    q_table_loaded = load_q_table()
    example_player_agg = 5
    example_dist = 250000 
    predicted_behavior = predict_nem_behavior(q_table_loaded, example_player_agg, example_dist)
    print(f"Predicted NemBehavior: {predicted_behavior}")
    weighted_aggression = get_weighted_aggression(q_table_loaded, example_player_agg, example_dist)
    print(f"Weighted Aggression Level: {weighted_aggression:.2f}")
