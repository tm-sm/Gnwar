extends Node2D

onready var spawner_manager = $SpawnerManager

var points = 0

var team

var objectives

func _ready():
	pass

func initialize(obj, tm):
	objectives = obj
	team = tm

func award_points(new_points):
	points += new_points

func create_wave():
	for n in points/UnitType.get_unit_cost(UnitType.basic):
		spawner_manager.buy_unit(UnitType.basic)
		points -= UnitType.basic

func get_random_objective()->Objective:
		randomize()
		if objectives.size() > 0:
			return objectives[randi() % objectives.size()]
		else:
			return null
