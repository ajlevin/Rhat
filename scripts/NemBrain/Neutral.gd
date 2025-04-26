class_name Neutral
extends Temperment

@onready var range : int = 50
@export var playerProjectile : Vector2

func update(_delta : float) -> void:
	dirToPlayer = nemesis.global_position.direction_to(player.global_position)
	nav_agent.target_position = player.global_position - \
		Vector2(range * dirToPlayer.x, 0)

func physics_update(_delta : float) -> void:
	# if player.global_position.x - nemesis.global_position.x < 0 : #player is left
	# else: # player is right
	randNum = rng.randf() # look into different selection methods
	curPlayerState = player.getCurPlayerState()
	#if ndc.getCurInput() != ndc.getLastInput():
		#print(ndc.NemInput.find_key(ndc.getCurInput()))
	
	if ndc.withinAttackRange():
		# print("attack range")
		if randNum < 0.5: # Melee
			ndc.setCurInput(ndc.NemInput.Melee)
		elif randNum < 0.7: # Burst
			ndc.setCurInput(ndc.NemInput.Burst)
		else: # Get hit
			ndc.setCurInput(ndc.getCurInput())
	elif ndc.incomingBlast():
		# print("incoming blast")
		if randNum < 0.25: # Counter
			ndc.setCurInput(ndc.NemInput.Counter)
		elif randNum < 0.25: # Dash
			ndc.setCurInput(ndc.NemInput.Dash)
		elif randNum < 0.25: # Jump
			ndc.setCurInput(ndc.NemInput.Jump)
		else: # Get hit
			ndc.setCurInput(ndc.getCurInput())
	elif curPlayerState is Airborne or curPlayerState is Jump:
		# print("player is up")
		if randNum < 0.8: # Run
			ndc.setCurInput(ndc.NemInput.Run)
		elif randNum < 0.95: # Jump
			ndc.setCurInput(ndc.NemInput.Jump)
		else: # Blast
			ndc.setCurInput(ndc.NemInput.Blast)
	elif ndc.playerApproaching(): # should be move with dash subset for rand weighting
		# print("player approaching")
		if randNum < 0.1: # Dash
			ndc.setCurInput(ndc.NemInput.Dash)
		elif randNum < 0.8: # Run
			ndc.setCurInput(ndc.NemInput.Run)
		elif randNum < 0.9: # Burst
			ndc.setCurInput(ndc.NemInput.Burst)
		else: # Jump
			ndc.setCurInput(ndc.NemInput.Jump)
	elif ndc.playerIsGrounded(): 
		# print("player is grounded")
		if randNum < 0.9: # Run
			ndc.setCurInput(ndc.NemInput.Run)
		elif randNum < 0.95: # Dash
			ndc.setCurInput(ndc.NemInput.Dash)
		else: # Blast
			ndc.setCurInput(ndc.NemInput.Blast)

func on_projectile_created(blast : Projectile) -> void:
	# blast.projectileCreated.connect()
	playerProjectile = ndc.incomingBlast()
