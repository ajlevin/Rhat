class_name Anxiety
extends Zone

@onready var anxiety_map : TileMapLayer = $"../../TileMaps/AnxietyMap"

### Enable the Anxiety realm TileMap
func enter() -> void:
	print("|-- Entering Anxiety --|")
	anxiety_map.enabled = true

### Disable the Anxiety realm TileMap
func exit() -> void:
	print("|-- Exiting Anxiety --|")
	anxiety_map.enabled = false
	
func update(_delta : float) -> void:
	pass
	
### TESTING -- USED TO SWAP BETWEEN REALMS
func physics_update(_delta : float) -> void:
	if Input.is_action_just_pressed("damage"):
		zone_transitioned.emit(self, "hate")

func disableMap() -> void:
	anxiety_map.enabled = false
