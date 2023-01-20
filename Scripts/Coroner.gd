extends Control

onready var counters = get_children()

func _on_unit_death(team):
	for c in counters:
		if c.team == team:
			c.increment()
			
