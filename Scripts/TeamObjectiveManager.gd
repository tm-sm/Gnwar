extends Node
class_name TeamObjectiveManager

signal all_objectives_destroyed
signal objective_damaged(total_hp, objectives_standing)

var objectives
var objectives_standing = 0
var total_objectives_hp = 0

export(Teams.team) var team

func _ready():
	objectives = get_children()
	print(objectives)
	for o in objectives:
		total_objectives_hp += o.points
		objectives_standing += 1
		o.connect("destroyed", self, "_remove_objective", [o])
		o.connect("damaged", self, "_on_objective_damaged")

func _on_objective_damaged(points):
	total_objectives_hp -= points
	emit_signal("objective_damaged", total_objectives_hp, objectives_standing)

func _remove_objective(o):
	objectives.erase(o)
	print("objective lost")
	if objectives.size() == 0:
		print("objectives gone")
		emit_signal("all_objectives_destroyed")
