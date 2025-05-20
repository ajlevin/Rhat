class_name NemStats
extends Stats

# Nem Stats
const SPEED : float = 190.0
const KICK_VELOCITY : float = 120.0
const DASH_VELOCITY : float = 500.0
const JUMP_VELOCITY : float = -360.0
const KICK_TIMER_DURATION : float = 0.15
const DASH_RESET_DURATION : float = 0.4
const WALL_SLIDE_VELOCITY : float = 80.0
const BURST_TIMER_DURATION : float = 5.0

# Nem state variables
@export var extraJump : bool = true
@onready var dash : bool = true : set = set_dash, get = get_dash
@export var wallKicking : int = 0
@onready var target : Vector2 = Vector2.ZERO : get = get_target
@export var countering : bool = false : set = set_countering, get = get_countering
@onready var burstCharges : int = 2 : set = set_burstCharges, get = get_burstCharges
var burstTimer : Timer = null

func _ready() -> void:
	maxHealth = 5
	immortal = true
	health = maxHealth

### Returns the nem's target
func get_target() -> Vector2:
	return target

### Sets whether a player can dash or not
func set_dash(val: bool) -> void:
	dash = val
	
### Returns whether the player can dash
func get_dash() -> bool:
	return dash
	
### Sets whether a player is countering or not
func set_countering(val: bool) -> void:
	countering = val
	
### Returns whether the player is countering
func get_countering() -> bool:
	return countering

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
	
func set_burstCharges(val: int) -> void:
	burstCharges = val
	print("set to " + str(val))
	
func get_burstCharges() -> int:
	return burstCharges

func increment_burstCharges() -> void:
	burstCharges += 1

func recharge_burst() -> void:
	if burstCharges < 2 and (burstTimer == null or burstTimer.is_stopped()):
		if burstTimer == null:
			burstTimer = Timer.new()
			burstTimer.one_shot = true
			add_child(burstTimer)
		
		if burstTimer.timeout.is_connected(set_immortality):
			burstTimer.timeout.disconnect(set_immortality)
		burstTimer.set_wait_time(BURST_TIMER_DURATION)
		burstTimer.timeout.connect(increment_burstCharges.bind())
		burstTimer.start()
		print("recharging")
	
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
