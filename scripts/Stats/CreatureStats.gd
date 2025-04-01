class_name CreatureStats
extends Stats

# Player Stats
const SPEED : float = 130.0
const DASH_VELOCITY : float = 360.0
const JUMP_VELOCITY : float = -330.0
const DASH_RESET_DURATION : float = 0.4

# Player state variables
@export var extraJump : bool = true
@onready var dash : bool = true : set = set_dash, get = get_dash

func _ready() -> void:
	maxHealth = 3
	immortal = false
	health = maxHealth

### Sets whether a player can dash or not
func set_dash(val: bool) -> void:
	dash = val
	
### Returns whether the player can dash
func get_dash() -> bool:
	return dash

### Sets max health (minimum of 1)
func set_max_health(val: int) -> void:
	var clamped = clamp(val, 1, val)
	
	if clamped != maxHealth:
		max_health_changed.emit(clamped - maxHealth)
		maxHealth = clamped
		
		if health > maxHealth:
			health = maxHealth
	
### Returns player's current max health
func get_max_health() -> int:
	return maxHealth
	
### Sets player immortality
func set_immortality(val: bool) -> void:
	immortal = val

### Returns if player is immortal or not
func get_immortality() -> bool:
	return immortal

### Sets player immortality for a given time before reverting to the opposite
func set_temp_immortality(time: float, val: bool) -> void:
	if immortalityTimer == null:
		immortalityTimer = Timer.new()
		immortalityTimer.one_shot = true
		add_child(immortalityTimer)
		
	if immortalityTimer.timeout.is_connected(set_immortality):
		immortalityTimer.timeout.disconnect(set_immortality)
	immortalityTimer.set_wait_time(time)
	immortalityTimer.timeout.connect(set_immortality.bind(!val))
	immortal = val
	immortalityTimer.start()

### Updates the player's health (minimum of 0), signaling if it hits 0
func set_health(val: int) -> void:	
	var clamped = max(maxHealth if val > maxHealth else val, health) \
		if immortal else clamp(val, 0, maxHealth)
	
	if clamped != health:
		print(get_parent().name + " took " + str(health - val) + " dmg")
		health_changed.emit(clamped - health)
		health = clamped
		
	if health == 0:
		health_zero.emit()
		print(get_parent().name + " hit 0 health")

### Returns the player's current health
func get_health() -> int:
	return health
