class_name Nem
extends Zone

@onready var hate_map: TileMapLayer = $"../../TileMaps/HateMap"
@onready var hate_plax: Node2D = $"../../Backgrounds/HatePlax"
@onready var hate_nav: NavigationRegion2D = $"../../NavLayers/HateNav"
@onready var hitboxNode : Resource = preload("res://scenes/Universal/hitbox.tscn")
@onready var collisionNode : Resource = preload("res://scenes/Universal/game_controller.tscn")
@onready var nemesis: Nemesis = $"../../Nemesis"

@export var lSpikes : Hitbox
@export var rSpikes : Hitbox
@export var lSpikeSpriteA : Sprite2D
@export var lSpikeSpriteB : Sprite2D
@export var rSpikeSpriteA : Sprite2D
@export var rSpikeSpriteB : Sprite2D

### Enable the Hate realm TileMap
func enter() -> void:
	print("|-- Entering Hate --|")
	hate_map.enabled = true
	hate_plax.visible = true
	hate_nav.enabled = true
	hate_nav.navigation_layers = 4
	nemesis.nav_agent.navigation_layers = 4
	
	var rect : RectangleShape2D = RectangleShape2D.new()
	rect.size = Vector2(90, 64)
	
	# Create left side arena spikes
	lSpikes = hitboxNode.instantiate()
	var lShape : CollisionShape2D = CollisionShape2D.new()
	lShape.shape = rect;
	lSpikes.add_child(lShape)
	lSpikes.global_position = Vector2(128, 386)
	lSpikes.set_damage(1)
	lSpikes.set_collision_layer_value(3, true)
	lSpikes.set_collision_mask_value(6, true)
	lSpikes.set_collision_layer_value(5, true)
	lSpikes.set_collision_mask_value(4, true)
	
	lSpikeSpriteA = Sprite2D.new()
	lSpikeSpriteA.texture = load("res://assets/Holders/crystals_black/crystal_black1.png")
	lSpikeSpriteA.global_position = Vector2(124, 392)

	lSpikeSpriteB = Sprite2D.new()
	lSpikeSpriteB.texture = load("res://assets/Holders/crystals_black/crystal_black2png")
	lSpikeSpriteB.global_position = Vector2(104, 386)
	lSpikeSpriteB.flip_h = true
	add_child(lSpikeSpriteA)
	add_child(lSpikeSpriteB)
	
	# Create right side arena spikes
	rSpikes = hitboxNode.instantiate()
	var rShape : CollisionShape2D = CollisionShape2D.new()
	rShape.shape = rect
	rSpikes.add_child(rShape)
	rSpikes.global_position = Vector2(704, 386)
	rSpikes.set_damage(1)
	rSpikes.set_collision_layer_value(3, true)
	rSpikes.set_collision_mask_value(6, true)
	rSpikes.set_collision_layer_value(5, true)
	rSpikes.set_collision_mask_value(4, true)

	rSpikeSpriteA = Sprite2D.new()
	rSpikeSpriteA.texture = load("res://assets/Holders/crystals_black/crystal_black2.png")
	rSpikeSpriteA.global_position = Vector2(700, 386)
	rSpikeSpriteA.flip_h = true
	
	rSpikeSpriteB = Sprite2D.new()
	rSpikeSpriteB.texture = load("res://assets/Holders/crystals_black/crystal_black1.png")
	rSpikeSpriteB.global_position = Vector2(700, 396)
	rSpikeSpriteB.flip_h = true
	add_child(rSpikeSpriteA)
	add_child(rSpikeSpriteB)

	add_child(lSpikes)
	add_child(rSpikes)
	
	nemesis.global_position = Vector2(584, 317)
	
### Disable the Hate realm TileMap
func exit() -> void:
	print("|-- Exiting Hate --|")
	hate_map.enabled = false
	hate_plax.visible = false
	hate_nav.enabled = false
	hate_nav.navigation_layers = 0
	
	lSpikes.queue_free()
	rSpikes.queue_free()
	
	lSpikeSpriteA.queue_free()
	lSpikeSpriteB.queue_free()
	rSpikeSpriteA.queue_free()
	rSpikeSpriteB.queue_free()
	
func update(_delta : float) -> void:
	pass
	
func begin_transition():
	zone_transitioned.emit(self, "identity")
	print("transition out of Hate")
	
### TESTING -- USED TO SWAP BETWEEN REALMS
func physics_update(_delta : float) -> void:
	if Input.is_action_just_pressed("damage"):
		zone_transitioned.emit(self, "identity")

func disableMap() -> void:
	hate_map.enabled = false
