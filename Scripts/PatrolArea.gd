extends Position2D
class_name PatrolArea

signal target_entered(body)
signal target_exited(body)

onready var patrol_area = $Range/CollisionShape2D

var alive = false
var team
var drag_enabled = false

var targets = Array()

func _ready():
	pass

func initialize(tm):
	team = tm

func _physics_process(delta):
	if drag_enabled:
		global_position = get_global_mouse_position()

func add_target(target):
	target.connect("died", self, "remove_target", [target])
	targets.append(target)

func remove_target(_team, target):
	targets.erase(target)
	emit_signal("target_exited", target)

func request_new_target()->Object:
	if targets.size() == 0:
		return null
	else:
		randomize()
		return targets[randi() % targets.size()]

func get_patrol_area():
	return patrol_area

func _on_Area2D_body_entered(body):
	if body.team != team:
		randomize()
		add_target(body)
		#at least one, this is made to prevent all units going after the same target
		var random_target = targets[randi() % targets.size()]
		emit_signal("target_entered", random_target)

func _on_Area2D_body_exited(body):
	if body and body.alive and body.team != team:
		remove_target(null, body)
		body.disconnect("died", self, "remove_target")


func _on_PickableArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			drag_enabled = event.pressed
