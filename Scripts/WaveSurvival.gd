extends Node2D

onready var str_settings = load("res://UI/AIvAIPreGameSettings.tscn")
onready var pause_screen = load("res://UI/PauseScreen.tscn")
onready var manager = $WaveSurvivalManager
onready var gui = $WaveSurvivalManager/Camera/GUI

export(bool) var pause_blocked = false

func _ready():
	gui.play_cinematic("fade_in", true)
#	var settings_panel = str_settings.instance()
#	settings_panel.connect("start_pressed", self, "_start_game")
#	add_child(settings_panel)
	_start_game()

func _start_game():
	manager.setup_game()
	
	gui.play_cinematic("wave_survival_intro", true)
	gui.get_cinematics_player().connect("animation_finished", self, "_on_intro_finished")
	#TODO fix the code above, it should acitvate the UI once the intro is finished

func _unhandled_input(event):
	if event.is_action_pressed("pause") and not pause_blocked:
		var pause_menu = pause_screen.instance()
		add_child(pause_menu)

func _on_game_over():
	get_tree().reload_current_scene()
