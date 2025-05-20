class_name StageController
extends Node

@onready var player: Player = $"../player"
@onready var nemesis: Nemesis = $"../Nemesis"
@onready var backgrounds: Node2D = $"../Backgrounds"
@onready var nav_layers: Node2D = $"../NavLayers"
@onready var transition_timer: Timer = $"../TransitionTimer"

@export var initialZone : Zone
@export var curZone : Zone
var zones : Dictionary = {}

### Collect all existing zones and set initial zone
func _ready() -> void:
	# Disables all backgrounds
	nemesis.nemDied.connect(on_nem_death)
	
	for background : Node2D in backgrounds.get_children():
		background.visible = false
		
	# Disables all navigation meshes
	for nav_layer : NavigationRegion2D in nav_layers.get_children():
		nav_layer.enabled = false
		nav_layer.navigation_layers = 0
	
	# Collects all zones that exist as children within the tree
	for child in get_children():
		if child is Zone:
			child.disableMap()
			zones[child.name.to_lower()] = child
			child.zone_transitioned.connect(on_zone_transition)
		
	# uses the initialZone if exists, otherwises defaults to "intro"
	if initialZone:
		initialZone.enter()
		curZone = initialZone
	else:
		zones["identity"].enter()
		curZone = zones["identity"]
	
### Updates current zone
func _process(delta) -> void:
	if curZone:
		curZone.update(delta)
		
### Updates current zones's physics
func _physics_process(delta) -> void:
	if curZone:
		curZone.physics_update(delta)
	
### Handles transitions from one zone to the next
func on_zone_transition(zone, newZoneName) -> void:
	### TESTING -- put player at default spawn location
	player.global_position = Vector2(195, 317)
	
	# reached if an inactive zone manages to emit a signal >:(
	if zone != curZone:
		return
	
	var newZone = zones.get(newZoneName.to_lower())
	# reached if the requested zone doesn't exist (check zone spelling)
	if !newZone:
		return
	
	# handle current zone exit
	if curZone:
		curZone.exit()
		
	# handle new zone entry and update current zone
	newZone.enter()
	curZone = newZone
	
func on_nem_death() -> void:
	if !transition_timer.timeout.is_connected(curZone.begin_transition):
		transition_timer.timeout.connect(curZone.begin_transition.bind())
	transition_timer.start()
