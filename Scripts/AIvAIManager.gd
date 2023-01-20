extends Node2D

enum spawners_strength {}

onready var custom_text_screen = load("res://UI/CustomTextScreen.tscn")

onready var spawners = $SpawnersManager.get_children()
onready var ObjManager = $ObjectivesManager
onready var objectives = $ObjectivesManager.get_children()

onready var gui = $Camera/GUI
onready var coroner = $Camera/GUI/Coroner
onready var camera = $Camera
onready var visible_area = $Restriction

var game_finished = false

func setup_game(g_strength, ag_strength, gb_hp, agb_hp):
	print("Setting up Spawners and Objectives")
	var gnome_time = difficulty_time(g_strength)
	var anti_gnome_time = difficulty_time(ag_strength)
	for spawner_groups in spawners:
		var spawners_of_team = spawner_groups.get_children()
		#now I have an array with all spawners of a given team
		
		#to link spawners with objectives
		var index = 0
		for spawner in spawners_of_team:
			#all spawners in team initialized
			match spawner.team:
				0: #Gnome
					spawner.initialize(self, gnome_time, coroner)
					gnome_time += gnome_time
				1: #AntiGnome
					spawner.initialize(self, anti_gnome_time, coroner)
					anti_gnome_time += anti_gnome_time
				_:
					spawner.initialize(self, 1.0, coroner)
					
			for objective_groups in objectives:
				for o in objective_groups.get_children():
					match o.team:
						0:#Gnome
							o.initialize(gb_hp, true)
						1:#AntiGnome
							o.initialize(agb_hp, true)
						_:
							o.initialize(100, true)
						
				var objectives_of_team = objective_groups.get_children()
				if objective_groups.team != spawner.team:
					#different teams, this should be a target
					spawner.add_objective(objectives_of_team)
					var aux = ""
					for o in objectives_of_team:
						aux += o.to_string() + " "
				else:
					#same team, spawners should be linked
					if index < objectives_of_team.size():
						spawner.link_objective(objectives_of_team[index])
						index += 1

	print("Setting up win conditions")
	ObjManager.connect("good_victory", self, "_good_victory")
	ObjManager.connect("evil_victory", self, "_evil_victory")
	print("Setting up camera")
	camera.initialize(visible_area, true, true)

func _good_victory():
	if not game_finished:
		game_finished = true
		var win_panel = custom_text_screen.instance()
		win_panel.text = "Gnomes win"
		add_child(win_panel)

func _evil_victory():
	if not game_finished:
		game_finished = true
		var win_panel = custom_text_screen.instance()
		win_panel.text = "Anti-Gnomes win"
		add_child(win_panel)

func difficulty_time(difficulty)->float:
	match difficulty:
		1.0:
			return 2.5
		2.0:
			return 1.5
		3.0:
			return 0.7
		4.0:
			return 0.3
		_:
			return 2.0

func enable_camera():
	camera.enabled = true

func disable_camera():
	camera.enabled = false
