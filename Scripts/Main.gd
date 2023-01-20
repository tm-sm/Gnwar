extends Node2D

onready var pause_screen = load("res://UI/PauseScreen.tscn")
onready var game_over_screen = load("res://UI/GameOverScreen.tscn")


func _ready():
	pass

func _game_over():
	var game_over_menu = game_over_screen.instance()
	add_child(game_over_menu)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_menu = pause_screen.instance()
		add_child(pause_menu)
		
