import numpy as np
from tensorflow.keras.models import Sequential, load_model
from tensorflow.keras.layers import Dense, Input
import matplotlib.pyplot as plt

# --- Step 1: Prepare Data ---
# Features: [PlayerAggression, DistanceToEnemy, LastBehavior]
X = np.array([
    [80, 10, 7],   # Sample 1
    [20, 85, 0],   # Sample 2
    [50, 50, 1],   # Sample 3
    [90, 5, 4],    # Sample 4
    [60, 30, 8]    # Sample 5
])

# Target: AggressionLevel (0-100)
y = np.array([95, 10, 50, 20, 70])

# Normalize inputs to [0, 1]
X_normalized = X / np.array([100, 100, 11])  # Max values for each feature

# --- Step 2: Build Model ---
model = Sequential([
    Input(shape=(3,)),  # Input layer (3 features)
    Dense(8, input_dim=3, activation='relu'),  # Input layer (3 features)
    Dense(4, activation='relu'),              # Hidden layer
    Dense(1, activation='linear')             # Output layer (0-100)
])

model.compile(optimizer='adam', loss='mse')  # Mean Squared Error for regression

# --- Step 3: Train Model ---
model.fit(X_normalized, y, epochs=500, verbose=0)

# --- Step 4: Test Prediction ---
test_input = np.array([[80, 10, 7]])  # Sample 1
test_input_normalized = test_input / np.array([100, 100, 11])
prediction = model.predict(test_input_normalized)[0][0]

print(f"Predicted Aggression: {prediction:.1f}") 

"""
# --- Step 5: Save Model ---
model.save('nem_model.h5')  # Save the trained model

# --- Step 6: Load Model ---
loaded_model = load_model('nem_model.h5')
loaded_prediction = loaded_model.predict(test_input_normalized)[0][0] # Test loaded model
print(f"Loaded Model Prediction: {loaded_prediction:.1f}")  # Should be ~95

# --- Step 7: Evaluate Model ---
# Evaluate on a new dataset 
X_test = np.array([
    [30, 70, 2],   # Sample 1
    [10, 90, 0],   # Sample 2
    [50, 50, 5]    # Sample 3
])
y_test = np.array([30, 5, 50])  # Expected Aggression Levels
X_test_normalized = X_test / np.array([100, 100, 11])
# Evaluate the model
loss = loaded_model.evaluate(X_test_normalized, y_test)
print(f"Test Loss: {loss:.4f}")  # Print the loss on the test set

# --- Step 8: Visualize Predictions ---
# Generate predictions
predictions = loaded_model.predict(X_test_normalized)
# Plot actual vs predicted
plt.scatter(y_test, predictions)
plt.xlabel('Actual Aggression Level')
plt.ylabel('Predicted Aggression Level')
plt.title('Actual vs Predicted Aggression Levels')
plt.plot([0, 100], [0, 100], 'r--')  # Diagonal line
plt.xlim(0, 100)
plt.ylim(0, 100)
plt.show()
"""