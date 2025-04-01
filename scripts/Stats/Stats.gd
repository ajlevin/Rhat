class_name Stats
extends Node

const GRAVITY : float = 900.0
const TERMINAL_VELOCITY : float = 600.0

# Player health signals
signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_zero

# Player health variables
@export var maxHealth : int : set = set_max_health, get = get_max_health
@export var immortal : bool : set = set_immortality, get = get_immortality
var immortalityTimer : Timer = null
@onready var health : int : set = set_health, get = get_health

### Sets max health (minimum of 1)
func set_max_health(val: int) -> void:
	pass
	
### Returns player's current max health
func get_max_health() -> int:
	return 0
	
### Sets player immortality
func set_immortality(val: bool) -> void:
	pass

### Returns if player is immortal or not
func get_immortality() -> bool:
	return true

### Sets player immortality for a given time before reverting to the opposite
func set_temp_immortality(time: float, val: bool) -> void:
	pass

### Updates the player's health (minimum of 0), signaling if it hits 0
func set_health(val: int) -> void:	
	pass

### Returns the player's current health
func get_health() -> int:
	return 0
