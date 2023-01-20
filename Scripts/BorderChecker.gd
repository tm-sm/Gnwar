extends Node2D

var can_move = false
var restriction

func initialize(restrict):
	restriction = restrict

func _check_if_entered(body):
	if body == self:
		can_move = true

func _check_if_exited(body):
	if body == self:
		can_move = false
