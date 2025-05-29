# scripts/test/TestNemBehavior.gd
extends Node

func _ready():
	var past := [0, 20, 40, 60, 80, 50, 30, 10, 0, 0]
	var prediction = NemModel.get_nem_behavior(7, 5, past)
	print("Predicted NemBehavior:", prediction)
