extends Node
class_name Restriction

onready var top_left = $TopLeft
onready var bottom_right = $BottomRight

var max_x 
var min_x
var max_y
var min_y

func _ready():
	max_x = bottom_right.position.x
	min_x = top_left.position.x
	max_y = bottom_right.position.y
	min_y = top_left.position.y
