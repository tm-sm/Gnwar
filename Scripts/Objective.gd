extends Node2D
class_name Objective

signal destroyed
signal damaged(hp)

export(int) var max_points : int = 1000
export(Teams.team) var team
export(bool) var active : bool = true
export(bool) var immortal : bool = false

var points = max_points

func initialize(max_points_custom, active):
	points = max_points_custom
	self.active = active

func _ready():
	points = max_points

func _on_Area2D_body_entered(body):
	if body.team != team:
		body.destroy()
		if not immortal:
			points -= body.damage
			if points <= 0:
				emit_signal("damaged", body.damage - points) #the difference to get damage to 0 and not -x
				emit_signal("destroyed")
				active = false
			else:
				emit_signal("damaged", points)
