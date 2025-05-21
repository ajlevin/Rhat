class_name Anxiety
extends Zone

@onready var anxiety_map : TileMapLayer = $"../../TileMaps/AnxietyMap"
@onready var anxiety_plax: Node2D = $"../../Backgrounds/AnxietyPlax"
@onready var slimeNode : Resource = preload("res://scenes/slime.tscn")
@onready var anxiety_nav: NavigationRegion2D = $"../../NavLayers/AnxietyNav"
@onready var nemesis: Nemesis = $"../../Nemesis"

### Enable the Anxiety realm TileMap
func enter() -> void:
	print("|-- Entering Anxiety --|")
	anxiety_map.enabled = true
	anxiety_plax.visible = true
	anxiety_nav.enabled = true
	anxiety_nav.navigation_layers = 2
	nemesis.nav_agent.navigation_layers = 2
	
	nemesis.global_position = Vector2(584, 317)

### Disable the Anxiety realm TileMap
func exit() -> void:
	print("|-- Exiting Anxiety --|")
	anxiety_map.enabled = false
	anxiety_plax.visible = false
	anxiety_nav.enabled = true

func update(_delta : float) -> void:
	pass

func begin_transition():
	zone_transitioned.emit(self, "hate")
	print("transition out of Anxiety")

### TESTING -- USED TO SWAP BETWEEN REALMS
func physics_update(_delta : float) -> void:
	if Input.is_action_just_pressed("damage"):
		zone_transitioned.emit(self, "hate")

func disableMap() -> void:
	anxiety_map.enabled = false
