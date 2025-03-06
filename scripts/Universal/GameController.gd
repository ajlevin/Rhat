class_name GameController
extends Node2D

@onready var stages: StageController = $Stages
@onready var killzone: Hitbox = $killzone
const KILLZONE_DAMAGE : int = 999

### Set initial stage on load to intro and set the killzone damage
func _ready() -> void:
	stages.initialZone = $Stages/Intro
	killzone.set_damage(KILLZONE_DAMAGE)
