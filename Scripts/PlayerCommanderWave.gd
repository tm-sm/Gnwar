extends Node2D
class_name PlayerCommanderWave

var selected_unit = 0

var team

var archer_tower = preload("res://Entities/structures/GnomeArcherTower.tscn")
var gnome_fortress = preload("res://Entities/structures/GnomeFortress.tscn")

var spawn_enabled = true

var world

func initialize(wrld, tm):
	world = wrld
	team = tm

func spawn_unit():
	#here the player commander should contact the wallet to check if it can buy
	var unit
	match selected_unit:
		0: #archer tower
			unit = archer_tower.instance()
			unit.initialize(world, team)
			unit.global_position = get_global_mouse_position()
		1: #gnome fortress
			unit = gnome_fortress.instance()
			unit.initialize(world, 10, 3.0, team)
			unit.global_position = get_global_mouse_position()
		_:
			unit = null
	world.add_child(unit)

func _unhandled_input(event):
	if Input.is_action_just_pressed("click") and spawn_enabled:
		spawn_unit()

func _input(event):
	if event.is_action_pressed("unit_type_1"):
		if selected_unit == 0 and spawn_enabled:
			spawn_enabled = false
		else:
			spawn_enabled = true
			selected_unit = 0
	if event.is_action_pressed("unit_type_2"):
		if selected_unit == 1 and spawn_enabled:
			spawn_enabled = false
		else:
			spawn_enabled = true
			selected_unit = 1

