class_name CameraController
extends Camera2D

@onready var identity_map: TileMapLayer = $"../../TileMaps/IdentityMap"

@onready var player : Player = $".."
@onready var plax_1: Node2D = $"../../Backgrounds/Plax1"

### Set bounds of the camera's movement to just beyond the stage bounds
func _ready() -> void:
	var mapRect = identity_map.get_used_rect()
	var tileSize = identity_map.tile_set.tile_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_left = -100 + 100 + 16
	limit_top = -100 + 100
	limit_right = worldSizeInPixels.x + 100 - 100
	limit_bottom = worldSizeInPixels.y + 100 - 100

### ---
func _process(delta) -> void:
	# TESTING -- REMOVE SOON AS DONE WITH CAMERA BS	
	#if Input.is_action_just_released("zoomIn"):
		#zoom += Vector2(0.25, 0.25)
	#if Input.is_action_just_released("zoomOut"):
		#zoom -= Vector2(0.25, 0.25)
	
	# ideally the offset is frontal, not lagging
	#position.x = (player.position.x + (20 *  -1 if player.sprite.flip_h else 1)) / 2
	pass
