extends Node
class_name UnitType

enum {basic}


func _ready():
	pass

static func get_unit_cost(unit_type)->int:
	match unit_type:
		basic:
			return 10
		_:
			return 0
