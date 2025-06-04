import random
import os
import csv
import json
from collections import deque

# === Configuration ===
NUM_BINS = 10                  # NemBehavior bins (0-100)
LEARNING_RATE = 0.1
DISCOUNT = 0.9
EPSILON = 0.2
MAX_HISTORY = 1000

# === Initialize Q-table ===
q_table = {}

# === Helper Functions ===
def decode_nem_state(nem_state: str) -> int:
    """Map nem_state string to an approximate behavior aggression value between 0 and 100."""
    mapping = {
        "Idle": 50,
        "Run": 50,
        "Jump": 50,
        "Airborne": 50,
        "Hit": 50,
        "Dead": 50,
        "Blast": 70,
        "Melee": 100,
        "Burst": 80,
        "Counter": 40,
        "Dash": 50,
        "OnWall": 35
    }
    return mapping.get(nem_state.replace("Nem", ""), 50)

def discretize_behavior(value: int) -> int:
    """Convert a NemBehavior value (0-100) into a bin index."""
    return min(NUM_BINS - 1, max(0, value // (100 // NUM_BINS)))

def make_state(player_agg: int, dist: int, past_behaviors: list[int]) -> tuple:
    """Make a hashable state representation."""
    simplified_past = tuple(b for b in past_behaviors[-MAX_HISTORY:])
    return (player_agg, dist, simplified_past)

def choose_action(state: tuple) -> int:
    """Choose an action index (0-9) using epsilon-greedy policy."""
    if state not in q_table:
        q_table[state] = [0.0 for _ in range(NUM_BINS)]
    if random.random() < EPSILON:
        return random.randint(0, NUM_BINS - 1)  # Explore
    return max(range(NUM_BINS), key=lambda i: q_table[state][i])  # Exploit

def update_q(state: tuple, action: int, reward: int, next_state: tuple):
    """Update the Q-table entry for the given state and action."""
    if next_state not in q_table:
        q_table[next_state] = [0.0 for _ in range(NUM_BINS)]
    current_q = q_table[state][action]
    max_future_q = max(q_table[next_state])
    q_table[state][action] += LEARNING_RATE * (reward + DISCOUNT * max_future_q - current_q)

# === Training Simulation ===
def train_step(player_agg: int, dist: int, past_behaviors: deque, reward: int, nem_behavior: int):
    state = make_state(player_agg, dist, list(past_behaviors))
    action = discretize_behavior(nem_behavior)
    next_state = make_state(player_agg, dist, list(past_behaviors))
    update_q(state, action, reward, next_state)

def train_step_2(player_agg: int, dist: int, past_behaviors: deque, reward: int) -> int:
    """Run one training step."""
    state = make_state(player_agg, dist, list(past_behaviors))
    action = nem_behavior
    # action = choose_action(state)
    # nem_behavior = action * (100 // NUM_BINS)  # Convert bin index to 0-100 range
    past_behaviors.append(nem_behavior)
    if len(past_behaviors) > MAX_HISTORY:
        past_behaviors.popleft()
    next_state = make_state(player_agg, dist, list(past_behaviors))
    update_q(state, action, reward, next_state)
    return nem_behavior

def train_model(epochs: int = 1000):
    past_behaviors = deque([0] * MAX_HISTORY, maxlen=MAX_HISTORY)
    for episode in range(epochs):
        player_agg = random.randint(0, 10)
        dist = random.randint(0, 10)
        reward = random.choice([-1, 0, 1])  # Placeholder: replace with game data later
        nem_behavior = train_step(player_agg, dist, past_behaviors, reward)
        if episode % 100 == 0:
            print(f"Episode {episode}: NemBehavior {nem_behavior}")

def load_and_train_from_logs(log_folder: str):
    NUM_EPOCHS = 10  # or 20, 50, depending on time and data size
    files = [f for f in os.listdir(log_folder) if f.endswith(".txt")]
    for epoch in range(NUM_EPOCHS):
        print(f"Epoch {epoch+1}/{NUM_EPOCHS}")
        for filename in files:
            print(f"Processing file: {filename}")

            filepath = os.path.join(log_folder, filename)
            with open(filepath, "r", newline='', encoding='utf-8') as txtfile:
                reader = csv.DictReader(txtfile)
                for row in reader:
                    try:
                        player_agg = int(float(row["playerAggression"]))
                        dist = int(float(row["distance"]))

                        past_encoded_list = json.loads(row["pastNemStatesENC"])
                        past_encoded = deque(past_encoded_list, maxlen=MAX_HISTORY)

                        nem_behavior_str = row["nemInput"]
                        nem_behavior = decode_nem_state(nem_behavior_str)

                        raw_reward = float(row["curReward"])
                        if raw_reward < 0:
                            reward = -1
                        elif raw_reward > 0:
                            reward = 1
                        else:
                            reward = 0

                        train_step(player_agg, dist, past_encoded, reward, nem_behavior)
                    except Exception as e:
                        print(f"Error processing row in {filename}: {e}")

def save_model(filepath="q_table.json"):
	with open(filepath, "w") as f:
		json.dump({str(k): v for k, v in q_table.items()}, f, indent=2)

# === Testing Simulation ===
def predict_behavior(player_agg: int, dist: int, past_behaviors: list[int]) -> int:
    """Predict the NemBehavior for the given state."""
    state = make_state(player_agg, dist, past_behaviors)
    if state not in q_table:
        return 50  # Default cautious behavior
    q_values = q_table[state]
    best_action = max(range(NUM_BINS), key=lambda i: q_values[i])
    return best_action * (100 // NUM_BINS)

def test_model_sample():
    test_past = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    player_agg = 7
    dist = 5
    predicted = predict_behavior(player_agg, dist, test_past)
    print("Predicted NemBehavior:", predicted)

# === Run Everything ===
if __name__ == "__main__":
    print("Training model from logs...")
    load_and_train_from_logs("../logs")
    print("Training complete.\n")

    save_model("q_table.json")
    print("Model saved to q_table.json\n")

    print("Testing model with sample data...")
    test_model_sample()
