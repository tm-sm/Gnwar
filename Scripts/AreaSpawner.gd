extends BaseSpawner
class_name AreaSpawner

export(int) var height : int = 250
export(int) var width : int = 250
var area_size = Vector2(height/2, width/2)

onready var area = $SpawnArea/AreaPreview.shape

func _ready():
	._ready()
	area.set_extents(area_size)

func get_spawn_position()->Vector2:
	var new_pos = Vector2()
	new_pos.x = rand_range(position.x - (width/2), position.x + (width/2))
	new_pos.y = rand_range(position.y - (height/2), position.y + (height/2))
	return new_pos
