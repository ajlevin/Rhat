class_name CameraController
extends Camera2D

@onready var intro_map: TileMapLayer = $"../../TileMaps/IntroMap"

@onready var player : Player = $".."

### Set bounds of the camera's movement to just beyond the stage bounds
func _ready():
	var mapRect = intro_map.get_used_rect()
	var tileSize = intro_map.tile_set.tile_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_left = -100
	limit_top = -100
	limit_right = worldSizeInPixels.x + 100
	limit_bottom = worldSizeInPixels.y + 100

### ---
func _process(delta):
	# ideally the offset is frontal, not lagging
	#position.x = (player.position.x + (20 *  -1 if player.sprite.flip_h else 1)) / 2
	pass
