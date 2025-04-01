class_name Neutral
extends Temperment

@onready var range : int = 50

func update(_delta : float) -> void:
	dirToPlayer = nemesis.global_position.direction_to(player.global_position)
	nav_agent.target_position = player.global_position - \
		Vector2(range * dirToPlayer.x, 0)
	
func physics_update(_delta : float) -> void:
	if ndc.withinAttackRange():
		ndc.setCurInput(ndc.NemInput.Melee)
	elif ndc.withinBlastRange():
		ndc.setCurInput(ndc.NemInput.Blast)
	elif ndc.incominagBlast():
		ndc.setCurInput(ndc.NemInput.Counter)
	elif ndc.playerApproaching():
		ndc.setCurInput(ndc.NemInput.Dash)
	elif ndc.playerIsFar():
		if true : #player is left
			ndc.setCurInput(ndc.NemInput.Left)
		else:
			ndc.setCurInput(ndc.NemInput.Right)
	
