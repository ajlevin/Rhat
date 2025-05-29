import random
import json
from collections import deque

# --- Config ---
NUM_BINS = 10
LEARNING_RATE = 0.1
DISCOUNT = 0.9
EPSILON = 0.2
MAX_HISTORY = 10

# --- Q-table ---
q_table = {}  # state → list of Q-values for each behavior bin (0–100)

# --- State Utilities ---
def discretize_behavior(val: int) -> int:
    return min(NUM_BINS - 1, max(0, val // (100 // NUM_BINS)))

def make_state(player_agg: int, dist: int, past: list[int]) -> tuple:
    simplified = tuple(discretize_behavior(b) for b in past[-MAX_HISTORY:])
    return (player_agg, dist, simplified)

# --- Q-Learning ---
def choose_action(state: tuple) -> int:
    if state not in q_table:
        q_table[state] = [0.0] * NUM_BINS
    return random.randint(0, NUM_BINS - 1) if random.random() < EPSILON else max(range(NUM_BINS), key=lambda i: q_table[state][i])

def update_q(state, action, reward, next_state):
    if next_state not in q_table:
        q_table[next_state] = [0.0] * NUM_BINS
    max_future = max(q_table[next_state])
    q_table[state][action] += LEARNING_RATE * (reward + DISCOUNT * max_future - q_table[state][action])

# --- Training Step ---
def train_step(player_agg, dist, past_behaviors, reward):
    state = make_state(player_agg, dist, list(past_behaviors))
    action = choose_action(state)
    nem_behavior = action * (100 // NUM_BINS)

    past_behaviors.append(nem_behavior)
    if len(past_behaviors) > MAX_HISTORY:
        past_behaviors.popleft()

    next_state = make_state(player_agg, dist, list(past_behaviors))
    update_q(state, action, reward, next_state)

    return nem_behavior

# --- Export Q-table to JSON ---
def save_model(filepath="q_table.json"):
    with open(filepath, "w") as f:
        json.dump({str(k): v for k, v in q_table.items()}, f, indent=2)

# --- Example Training Simulation ---
if __name__ == "__main__":
    past = deque([0] * MAX_HISTORY, maxlen=MAX_HISTORY)

    # Simulate 1000 training steps
    for _ in range(1000):
        p_agg = random.randint(0, 10)
        dist = random.randint(0, 10)
        reward = random.choice([-1, 0, 1])  # Replace with real game data later
        train_step(p_agg, dist, past, reward)

    save_model()
    print("Training complete. Model saved to q_table.json.")
