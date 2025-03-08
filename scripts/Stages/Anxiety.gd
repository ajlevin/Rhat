class_name Anxiety
extends Zone

@onready var anxiety_map : TileMapLayer = $"../../TileMaps/AnxietyMap"
@onready var slimeNode : Resource = preload("res://scenes/slime.tscn")

@export var slime : Slime

### Enable the Anxiety realm TileMap
func enter() -> void:
	print("|-- Entering Anxiety --|")
	anxiety_map.enabled = true
	
	slime = slimeNode.instantiate()
	slime.global_position = Vector2(374, 180)
	add_child(slime)

### Disable the Anxiety realm TileMap
func exit() -> void:
	print("|-- Exiting Anxiety --|")
	anxiety_map.enabled = false
	
	slime.queue_free()
	
func update(_delta : float) -> void:
	pass
	
### TESTING -- USED TO SWAP BETWEEN REALMS
func physics_update(_delta : float) -> void:
	if Input.is_action_just_pressed("damage"):
		zone_transitioned.emit(self, "hate")

func disableMap() -> void:
	anxiety_map.enabled = false
