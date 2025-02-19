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
@onready var central_ray = $Rays/midBump
@onready var right_ray = $Rays/rightBump
@onready var left_ray = $Rays/leftBump

var jumpBuffered : bool = false
var coyoteTime : bool = false
var wasOnFloor : bool = true
var extraJump : bool = true

@export var actionable : bool = true

@onready var sprite = $AnimatedSprite
@onready var animation_player = $AnimationPlayer 
@onready var kick_timer = $Timers/KickTimer
@onready var stats = $stats

func _ready():
	actionable = true
	
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
		pass
		# die()

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
			coyoteTime = false # jump
		elif is_on_wall_only():
			velocity.y = JUMP_VELOCITY # wall jump
			actionable = false
			kick_timer.start(KICK_TIMER_DURATION)
			velocity.x = KICK_SPEED * direction.x
			move_and_slide()
			return
		elif extraJump:
			velocity.y = JUMP_VELOCITY # jump
			extraJump = false
		else:
			jumpBuffered = true # no jump
			jump_buffer_timer.start(JUMP_BUFFER_DURATION)
		
		# no coyote time from jumping -- only from walking off an edge
		wasOnFloor = false
		coyoteTime = false
	
	move_and_slide()
