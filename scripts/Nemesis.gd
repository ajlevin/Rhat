class_name Nemesis
extends CharacterBody2D

@onready var player_tracker: RayCast2D = $Rays/playerTracker
@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var stats: NemStats = $stats

func _ready() -> void:
	nav_agent.path_desired_distance = 40
	nav_agent.target_desired_distance = 40
	nav_agent.simplify_path = false
	actor_setup.call_deferred()

func actor_setup():
	await get_tree().physics_frame
	nav_agent.target_position = player.global_position

### Update raycast tracking player location and distance
func _process(delta: float) -> void:
	player_tracker.target_position = \
		global_position.direction_to(player.global_position) * 30

### Moves nemesis based on currently set values each tick
func _physics_process(_delta : float) -> void:
	# global_position.direction_to(nav_agent.get_next_path_position()) * stats.SPEED
	# nav_agent.get_next_path_position()
	move_and_slide()
