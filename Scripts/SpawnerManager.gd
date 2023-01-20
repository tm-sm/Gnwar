extends Node2D

signal wave_finished

onready var timer = $Timer
onready var spawners = get_children()
onready var spawners_finished = 0

#to add the units to each spawner
var spawner_index = 0

var wave_cooldown = 10.0

func _ready():
	spawners.erase(timer)
	for spawner in spawners:
		spawner.connect("all_units_spawned", self, "_on_spawner_finished")

func buy_unit(unit_type):
	#assuming there's spawners already set
	if spawner_index == spawners.size():
		spawner_index = 0
	spawners[spawner_index].add_unit(unit_type)
	spawner_index += 1

func release_wave():
	spawners_finished = 0
	for spawner in spawners:
		spawner.spawn_wave()

func _on_spawner_finished():
	spawners_finished += 1
	if spawners_finished == spawners.size():
		emit_signal("wave_finished")
		timer.start(wave_cooldown)
		timer.set_one_shot(true)

func get_spawners()->Array:
	return spawners


func _on_Timer_timeout():
	release_wave()
