extends Node2D

onready var wave_survival_game = get_parent()
onready var player_commander = $PlayerCommander
onready var enemy_commander = $EnemyCommander
onready var coroner = $Coroner

onready var camera = $Camera
onready var visible_area = $Restriction

var wave
var base_health

func _ready():
	wave = 1
	base_health = 100000

func setup_game():
	print("Setting up enemy spawners")
	var spawner_manager = $EnemyCommander/SpawnerManager
	spawner_manager.connect("wave_finished", self, "_on_wave_finished")
	for spawner in spawner_manager.get_spawners():
		spawner.initialize(self, 0.1, coroner)
		spawner.set_commander(enemy_commander)
	print("Setting up enemy commander objectives")
	var pseudo_objectives = $PlayerCommander/PseudoObjectives.get_children()
	for objective in pseudo_objectives:
		objective.initialize(100, true)
	enemy_commander.initialize(pseudo_objectives, Teams.team.ANTIGNOME)
	print("Setting up player commander base and control")
	player_commander.initialize(self, Teams.team.GNOME)
	var base = $PlayerCommander/Base
	base.initialize(base_health, true)
	base.connect("destroyed", wave_survival_game, "_on_game_over")
	print("Setting up camera")
	camera.initialize(visible_area, true, true)
	print("Starting first wave")
	enemy_commander.award_points(wave * 100)
	enemy_commander.create_wave()

func _on_wave_finished():
	wave += 1
	print(wave)
	enemy_commander.award_points(wave * 100)
	enemy_commander.create_wave()
