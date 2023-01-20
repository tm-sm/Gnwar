extends Node2D

onready var str_settings = load("res://UI/AIvAIPreGameSettings.tscn")
onready var pause_screen = load("res://UI/PauseScreen.tscn")
onready var manager = $AIvAIManager
onready var gui = $AIvAIManager/Camera/GUI

export(bool) var pause_blocked = false

func _ready():
	gui.play_cinematic("fade_in", true)
	var settings_panel = str_settings.instance()
	settings_panel.connect("start_pressed", self, "_start_game")
	add_child(settings_panel)

func _start_game(g_strength, ag_strength, gb_hp, agb_hp):
	#gb_hp = gnome base hitpoints
	manager.setup_game(g_strength, ag_strength, gb_hp, agb_hp)
	gui.play_cinematic("ai_v_ai_intro", true)
	gui.get_cinematics_player().connect("animation_finished", self, "_on_intro_finished")

func _unhandled_input(event):
	if event.is_action_pressed("pause") and not pause_blocked:
		var pause_menu = pause_screen.instance()
		add_child(pause_menu)
