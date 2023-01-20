extends Node2D
class_name PatrolSpawner

signal spawned_unit

export(bool) var active : bool
export(String) var path_from_entity = "ai/PatrollingAI.tscn"
export(float) var unit_scale : float = 1
export(Teams.team) var team
export(float) var spawn_time = 2.0

onready var timer = $SpawnTimer

var world
var entity
var coroner
var commander

func _ready():
	entity = load("res://Entities/" + path_from_entity)

func initialize(wrld, time, crnr, comm):
	world = wrld
	spawn_time = time
	timer.start(spawn_time)
	timer.set_one_shot(false)
	coroner = crnr
	commander = comm
	active = true

func activate():
	active = true

func deactivate():
	active = false

func _on_SpawnTimer_timeout():
	if active:
		spawn()

func get_spawn_position()->Vector2:
	return global_position

func spawn():
	var aux = entity.instance()
	var pos = get_spawn_position()
	aux.initialize(commander, pos)
	aux.scale.x = unit_scale
	aux.scale.y = unit_scale
	aux.connect("died", coroner, "_on_unit_death")
	emit_signal("spawned_unit")
	world.add_child(aux)

