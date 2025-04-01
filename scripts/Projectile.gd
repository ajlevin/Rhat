class_name Projectile
extends CharacterBody2D

const SPEED : int = 600
const DURATION : int = 1

@onready var hitboxNode : Resource = preload("res://scenes/Universal/hitbox.tscn")
@onready var hitbox: Hitbox
@onready var animated_sprite: AnimatedSprite2D

@onready var stun : bool = false
@export var dir : int
@export var fired : bool = false
@export var destination : int

func reverse(isPlayer : bool):
	hitbox.collision_layer = 0
	hitbox.collision_mask = 0
	if isPlayer:
		hitbox.set_collision_layer_value(5, true)
		hitbox.set_collision_mask_value(4, true)
	else:
		hitbox.set_collision_layer_value(3, true)
		hitbox.set_collision_mask_value(6, true)
	
	stun = true
	# hitbox.set_damage(0)
	dir *= -1
	destination = global_position.x + (300 * dir)

func _physics_process(_delta: float) -> void:
	if fired:
		if (dir == -1 and global_position.x <= destination) \
			or (dir == 1 and global_position.x >= destination):
			queue_free()
		velocity.x = SPEED * dir
		move_and_slide()
	if is_on_wall() or global_position.x < 80 or global_position.x > 740:
		queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if (area is Hurtbox):
		if area.is_countering():
			if area.get_parent() is Slime:
				reverse(false)
			# print(area.get_parent().name)
			pass
		elif area.is_invincible():
			pass
		else:
			# await get_tree().create_timer(0.05).timeout
			queue_free()

func create(pos : Vector2, direction : int, cLayer : int, cMask : int) -> void:
	dir = direction
	global_position = pos + Vector2(40 * dir, 0)
	destination = global_position.x + (300 * dir)
	stun = false
	fired = true
	animated_sprite = $AnimatedSprite
	animated_sprite.z_index = 1
	
	hitbox = $Hitbox
	hitbox.collision_layer = 0
	hitbox.collision_mask = 0
	hitbox.set_collision_layer_value(cLayer, true)
	hitbox.set_collision_mask_value(cMask, true)
	hitbox.set_damage(1)
