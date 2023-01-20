extends Node2D

onready var pause_screen = load("res://UI/PauseScreen.tscn")
onready var custom_text_screen = load("res://UI/CustomTextScreen.tscn")

onready var spawners = $SpawnersManager.get_children()
onready var ObjManager = $ObjectivesManager
onready var objectives = $ObjectivesManager.get_children()

func _ready():
	print("Setting up Spawners")
	for spawner_groups in spawners:
		var spawners_of_team = spawner_groups.get_children()
		#now I have an array with all spawners of a given team
		
		for spawner in spawners_of_team:
			#all spawners in team initialized
			spawner.initialize(self, 2.0, null)
			print(spawner.to_string() + " initialized")
			for objective_groups in objectives:
				var objectives_of_team = objective_groups.get_children()
				if objective_groups.team != spawner.team:
					#different teams, this should be a target
					spawner.add_objective(objectives_of_team)
