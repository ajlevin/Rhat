class_name Intro
extends Zone

@onready var intro_map: TileMapLayer = $"../../TileMaps/IntroMap"

### Disable the Intro realm TileMap
func enter():
	print("|-- Entering Intro --|")
	intro_map.enabled = true
	
### Disable the Intro realm TileMap
func exit():
	print("|-- Exiting Intro --|")
	intro_map.enabled = false
	
func update(_delta : float):
	pass
	
### TESTING -- USED TO SWAP BETWEEN REALMS
func physics_update(_delta : float):
	if Input.is_action_just_pressed("damage"):
		zone_transitioned.emit(self, "anxiety")
