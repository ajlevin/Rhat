class_name Hurtbox
extends Area2D

signal damaged(damage: int)
## !! stats must always be on the same level as the hurtbox/hitbox !!
@onready var stats : Stats = $"../stats"
## key: hitbox instance id | value: timer node variable
@export var hitboxTimers : Dictionary = {}

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _process(delta) -> void:
	pass

func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox != null:
		hitboxTimers[hitbox.get_instance_id()] = \
			set_damage_timer(hitbox.damage, hitbox.get_instance_id())
		print("entered " + hitbox.get_parent().name)
		stats.health -= hitbox.damage
		damaged.emit(hitbox.damage)

func _on_area_exited(hitbox: Hitbox) -> void:
	if hitbox != null:
		print("stopping " + str(hitboxTimers.get(hitbox.get_instance_id())))
		hitboxTimers.get(hitbox.get_instance_id()).stop()
		hitboxTimers.erase(hitbox.get_instance_id())
		print("left " + hitbox.get_parent().name)

func is_countering() -> bool:
	if (stats is PlayerStats) or (stats is NemStats):
		return stats.countering
	else:
		return false

func is_invincible() -> bool:
	if (stats is PlayerStats) or (stats is NemStats):
		return stats.get_immortality()
	else:
		return false

func tick_damage(dmg : int, hitboxId : int) -> void:
	var curHitbox : Hitbox = instance_from_id(hitboxId)
	
	if curHitbox != null and !curHitbox.is_disabled():
		stats.health -= dmg
		set_damage_timer(dmg, hitboxId)

func set_damage_timer(dmg : int, hitboxId : int) -> Timer:
	var damageTimer : Timer = Timer.new()
	
	damageTimer = Timer.new()
	damageTimer.one_shot = true
	add_child(damageTimer)

	if damageTimer.timeout.is_connected(tick_damage):
		damageTimer.timeout.disconnect(tick_damage)
	damageTimer.set_wait_time(1)
	damageTimer.timeout.connect(tick_damage.bind(dmg, hitboxId))
	damageTimer.start()
	
	return damageTimer
