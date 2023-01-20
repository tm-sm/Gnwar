extends Node2D

var selected_unit = load("res://Entities/ai/ally/AllyGnome.tscn")
var world
var move_order = load("res://Entities/triggers/MoveOrder.tscn").instance()


func initialize(world):
	self.world = world
	world.add_child(move_order)
	move_order.deactivate()

func _physics_process(delta):
	if Input.is_action_just_pressed("click"):
		spawn_unit()
	if Input.is_action_just_pressed("move_here"):
		set_move_order_position()

func spawn_unit():
	var unit = selected_unit.instance()
	unit.initialize(null, null, move_order, get_global_mouse_position())
	world.add_child(unit)
	
func set_move_order_position():
	move_order.activate()
	move_order.position = get_global_mouse_position()
