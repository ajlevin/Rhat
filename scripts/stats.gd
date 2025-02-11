class_name Stats
extends Node2D

signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_zero

@export var maxHealth : int = 3 : set = set_max_health, get = get_max_health
@export var immortal : bool = false : set = set_immortality, get = get_immortality

var immortalityTimer: Timer = null
@onready var health : int = maxHealth : set = set_health, get = get_health

func set_max_health(val: int):
	var clamped = clamp(val, 1, val)
	
	if clamped != maxHealth:
		max_health_changed.emit(clamped - maxHealth)
		maxHealth = clamped
		
		if health > maxHealth:
			health = maxHealth
	
func get_max_health() -> int:
	return maxHealth
	
func set_immortality(val: bool):
	immortal = val
	
func get_immortality() -> bool:
	return immortal

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

func set_health(val: int):	
	var clamped = max(val, health) if immortal else clamp(val, 0, maxHealth)
	
	if clamped != health:
		health_changed.emit(clamped - health)
		health = clamped
		
	if health == 0:
		health_zero.emit()
		print(get_parent().name + " hit 0 health")
		
	print(get_parent().name + " took val " + str(health - val) + " dmg")

func get_health() -> int:
	return health
