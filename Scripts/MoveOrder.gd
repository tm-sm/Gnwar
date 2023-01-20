extends Node2D
class_name MoveOrder

onready var area = $Area/CollisionShape2D

var active = false

func activate():
	active = true

func deactivate():
	active = false
