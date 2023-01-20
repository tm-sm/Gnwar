extends PanelContainer
class_name DeathStats

export(Teams.team) var team
onready var counter = $Counter

func _ready():
	pass

func increment():
	counter.increment()

func decrement():
	counter.decrement()
