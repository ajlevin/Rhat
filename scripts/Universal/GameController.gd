class_name GameController
extends Node2D

@onready var stages: StageController = $Stages
@onready var hitbox: Hitbox = $hitbox
const KILLZONE_DAMAGE = 999

### Set initial stage on load to intro and set the killzone damage
func _ready():
	stages.initialZone = $Stages/Intro
	hitbox.set_damage(KILLZONE_DAMAGE)
