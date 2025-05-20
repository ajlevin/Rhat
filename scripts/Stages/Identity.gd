class_name Intro
extends Zone

@onready var identity_map: TileMapLayer = $"../../TileMaps/IdentityMap"
@onready var identity_plax: Node2D = $"../../Backgrounds/IdentityPlax"
@onready var identity_nav: NavigationRegion2D = $"../../NavLayers/IdentityNav"

### Disable the Identity realm TileMap
func enter() -> void:
	print("|-- Entering Identity --|")
	identity_map.enabled = true
	identity_plax.visible = true
	identity_nav.enabled = true
	
### Disable the Intro realm TileMap
func exit() -> void:
	print("|-- Exiting Identity --|")
	identity_map.enabled = false
	identity_plax.visible = false
	identity_nav.enabled = false
	
func update(_delta : float) -> void:
	pass
	
### TESTING -- USED TO SWAP BETWEEN REALMS
func physics_update(_delta : float) -> void:
	if Input.is_action_just_pressed("damage"):
		zone_transitioned.emit(self, "anxiety")

func disableMap() -> void:
	identity_map.enabled = false
