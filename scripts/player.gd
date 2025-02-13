extends CharacterBody2D
class_name Player

const GRAVITY = 900
const SPEED = 130.0
const KICK_SPEED = -60.0
const JUMP_VELOCITY = -330.0
const JUMP_BUFFER_DURATION = 0.1
const KICK_TIMER_DURATION = 0.15

@onready var jump_buffer_timer = $Timers/JumpBufferTimer
@onready var coyote_timer = $Timers/CoyoteTimer
@onready var central_ray = $Rays/centralRay
@onready var right_ray = $Rays/rightRay
@onready var left_ray = $Rays/leftRay

var jumpBuffered : bool = false
var coyoteTime : bool = false
var wasOnFloor : bool = true
var extraJump : bool = true
var attacking : bool = false
@export var actionable : bool = true
var damage : int = 1

@onready var sprite = $AnimatedSprite
@onready var animation_player = $AnimationPlayer 
@onready var kick_timer = $Timers/KickTimer
@onready var stats = $stats

func _ready():
	actionable = true

func _on_health_zero():
	die()
	
func _on_stats_health_changed(diff):
	if diff < 0:
		animation_player.play("hitBlink")

func die():
	velocity.x = 0
	actionable = false
	animation_player.play("death")

func reload_scene():
	get_tree().reload_current_scene()
	
func _on_kick_timer_timeout():
	extraJump = true
	actionable = true

func _on_jump_buffer_timer_timeout():
	jumpBuffered = false
	
func _on_coyote_timer_timeout():
	coyoteTime = false  

func _process(_delta : float):
	var anim  = animation_player.current_animation
	if Input.is_action_just_pressed("damage"):
		die()
		
	#if animation_player.current_animation != anim:
		#print("Current:" + animation_player.current_animation)
		#print("Var:" + anim)

# Physics processing
func _physics_process(delta):
	# Get user directional input
	var direction = Input.get_vector("move_left", "move_right", "move_down", "move_up")
	
	# Add the gravity or refresh double jump.
	if not is_on_floor():
		if wasOnFloor:
			coyoteTime = true
			coyote_timer.start(JUMP_BUFFER_DURATION)
		wasOnFloor = false
		velocity.y += GRAVITY * delta
	else:
		wasOnFloor = true
		extraJump = true
	
	if not actionable:
		move_and_slide()
		return
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") or (is_on_floor() and jumpBuffered):
		# raycasting jump bump
		if right_ray.is_colliding() and \
		!(central_ray.is_colliding() or left_ray.is_colliding()):
			self.position.x -= 5
		elif left_ray.is_colliding() and \
		!(central_ray.is_colliding() or right_ray.is_colliding()):
			self.position.x += 5
			
		
		if is_on_floor() or coyoteTime:
			velocity.y = JUMP_VELOCITY
			coyoteTime = false
		elif is_on_wall_only():
			# this detection may be wack? could use tuning
			velocity.y = JUMP_VELOCITY
			actionable = false
			kick_timer.start(KICK_TIMER_DURATION)
			velocity.x = KICK_SPEED * direction.x
			move_and_slide()
			return
		elif extraJump:
			velocity.y = JUMP_VELOCITY
			extraJump = false
		else:
			jumpBuffered = true
			jump_buffer_timer.start(JUMP_BUFFER_DURATION)
		# technically doesn't do anything but eh
		# # action_state = STATE.AIR
		
		# no coyote time from jumping -- only from walking off an edge
		wasOnFloor = false
		coyoteTime = false
	
	if Input.is_action_just_released("jump") && velocity.y < -40:
		velocity.y *= 0.1
	
	# Get the input direction and handle the movement/deceleration.
	if direction.x:
		velocity.x = direction.x * SPEED
		if !animation_player.is_playing():
			sprite.play("run")
		if (direction.x > 0):
			sprite.flip_h = false
			# attack.scale.x = 1
		else:
			sprite.flip_h = true
			# attack.scale.x = -1
	else:
		if !animation_player.is_playing():
			sprite.play("idle")
		velocity.x = 0
	
	move_and_slide()
