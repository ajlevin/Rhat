class_name CameraController
extends Camera2D

@onready var tile_map = $"../../TileMap"
@onready var player = $".."

func _ready():
	var mapRect = tile_map.get_used_rect()
	var tileSize = tile_map.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_left = -100
	limit_top = -100
	limit_right = worldSizeInPixels.x + 100
	limit_bottom = worldSizeInPixels.y + 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# ideally the offset is frontal, not lagging
	#position.x = (player.position.x + (20 *  -1 if player.sprite.flip_h else 1)) / 2
	pass
