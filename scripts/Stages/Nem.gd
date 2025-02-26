class_name Nem
extends Zone

@onready var nem_map: TileMapLayer = $"../../TileMaps/NemMap"

### Disable the Nem realm TileMap
func enter():
	print("|-- Entering Nem --|")
	nem_map.enabled = true
	
### Disable the Nem realm TileMap
func exit():
	print("|-- Exiting Nem --|")
	nem_map.enabled = false
	
func update(_delta : float):
	pass
	
### TESTING -- USED TO SWAP BETWEEN REALMS
func physics_update(_delta : float):
	if Input.is_action_just_pressed("damage"):
		zone_transitioned.emit(self, "intro")
