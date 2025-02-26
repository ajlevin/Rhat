class_name Stats
extends Node2D

# Player Stats
const GRAVITY = 900
const SPEED = 130.0
const KICK_SPEED = -60.0
const JUMP_VELOCITY = -330.0
const JUMP_BUFFER_DURATION = 0.1
const COYOTE_TIME_DURATION = 0.08
const KICK_TIMER_DURATION = 0.15
const TERMINAL_VELOCITY = 600

# Player health signals
signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_zero

# Player state variables
@onready var jumpBuffered : bool = false
@onready var coyoteTime : bool = false
@onready var wasOnFloor : bool = true
@onready var extraJump : bool = true
@export var actionable : bool = true

# Player health variables
@export var maxHealth : int = 3 : set = set_max_health, get = get_max_health
@export var immortal : bool = false : set = set_immortality, get = get_immortality
var immortalityTimer: Timer = null
@onready var health : int = maxHealth : set = set_health, get = get_health

### Sets max health (minimum of 1)
func set_max_health(val: int):
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
func set_immortality(val: bool):
	immortal = val

### Returns player's current immortality
func get_immortality() -> bool:
	return immortal

### Sets player immortality for a given time before reverting to the opposite
func set_temp_immortality(time: float, val: bool):
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
func set_health(val: int):	
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
