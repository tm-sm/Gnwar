extends Node2D
class_name BaseSpawner

signal out_of_objectives
signal spawned_unit

export(bool) var active : bool
export(String) var path_from_entity = "ai/BaseAI.tscn"
export(float) var unit_scale : float = 1
export(Teams.team) var team
export(float) var spawn_time = 2.0

onready var timer = $SpawnTimer

var objectives = []
var world
var entity
var linked_objective
var coroner
var commander = self

func _ready():
	entity = load("res://Entities/" + path_from_entity)

func initialize(wrld, time, crnr):
	world = wrld
	spawn_time = time
	timer.start(spawn_time)
	timer.set_one_shot(false)
	coroner = crnr
	active = true

func add_objective(objective):
	objectives += objective
	for obj in objective:
		obj.connect("destroyed", self, "_remove_objective", [obj])

func _remove_objective(objective):
	objectives.erase(objective)
	if objectives.size() == 0:
		emit_signal("out_of_objectives")

func link_objective(objective):
	linked_objective = objective
	linked_objective.connect("destroyed", self, "_deactivate")

func activate():
	active = true

func deactivate():
	active = false

func _on_SpawnTimer_timeout():
	if active and commander.objectives.size() > 0:
		var objective = get_random_objective()
		spawn()

func get_random_objective()->Objective:
		randomize()
		if objectives.size() > 0:
			return objectives[randi() % objectives.size()]
		else:
			
			return null

func get_spawn_position()->Vector2:
	return position

func spawn():
	var objective = commander.get_random_objective()
	var aux = entity.instance()
	var pos = get_spawn_position()
	aux.initialize(commander, objective, null, pos)
	aux.scale.x = unit_scale
	aux.scale.y = unit_scale
	aux.connect("died", coroner, "_on_unit_death")
	emit_signal("spawned_unit")
	world.add_child(aux)

