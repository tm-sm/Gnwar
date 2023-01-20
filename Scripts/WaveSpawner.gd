extends BaseSpawner
class_name WaveSpawner

var basic_unit = load("res://Entities/ai/enemy/EnemyGnome.tscn")

signal all_units_spawned

var wave : Array

func _ready():
	activate()
	spawn_time = 0.1
	timer.start(spawn_time)
	timer.set_one_shot(false)

func set_commander(comm):
	commander = comm

func add_unit(unit_type):
	wave.push_front(unit_type)

func spawn_wave():
	activate()

func _on_SpawnTimer_timeout():
	if active and commander.objectives.size() > 0:
		if wave.size() != 0:
			var next_unit = wave.pop_front()
			match next_unit:
				UnitType.basic: #antignome
					entity = basic_unit
				_:
					#TEMPORARY
					entity = basic_unit
			var objective = get_random_objective()
			spawn()
		else:
			emit_signal("all_units_spawned")
			deactivate()
