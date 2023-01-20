extends KinematicBody2D
class_name GnomeFortress

onready var effects = $StructureEffects
onready var animation = $AnimationPlayer
onready var sprite = $Sprite
onready var spawner = $UnitSpawner
onready var patrol_area = $PatrolArea

export(Teams.team) var team
export(int) var hp_max: int = 100
export(int) var hp : int = hp_max
export(float) var defense: float = 0
export(int) var damage = 50
export(int) var arrow_speed = 450

var alive = true
var unit_type

var world
var time

var max_units
var active_units = 0

func _ready():
	patrol_area.initialize(team)
	spawner.initialize(world, time, self, patrol_area)
	spawner.connect("spawned_unit", self, "_on_spawned_unit")
	spawner.path_from_entity = "/ai/PatrollingAI.tscn"
	spawner.team = Teams.team.GNOME

func initialize(wrld, max_un, tim, tm):
	max_units = max_un
	world = wrld
	time = tim
	team = tm

func recieve_damage(entity):
	var reduction = entity.damage * defense
	hp -= entity.damage - reduction
	if hp <= 0:
		die()
	else:
		on_hit()

func on_hit():
	effects.play("on_hit")

func die():
	alive = false
	emit_signal("died", team)
	animation.stop()
	effects.play("die")

func destroy():
	#like die, but without an animation
	emit_signal("died", team)
	queue_free()

func _on_unit_spawned():
	active_units += 1
	if active_units >= max_units:
		spawner.deactivate()

func _on_unit_death():
	active_units -= 1
	if not spawner.active and active_units < max_units:
		spawner.activate()
