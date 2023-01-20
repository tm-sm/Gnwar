extends Position2D
class_name BaseStructure

onready var effects = $StructureEffects
onready var animation = $AnimationPlayer
onready var sprite = $Sprite

var arrow = preload("res://Entities/misc/Projectile.tscn")

export(Teams.team) var team
export(int) var hp_max: int = 100
export(int) var hp : int = hp_max
export(float) var defense: float = 0
export(int) var damage = 50
export(int) var arrow_speed = 450

var alive = true

func _ready():
	pass

func recieve_damage(entity):
	var reduction = entity.damage * defense
	hp -= entity.damage - reduction
	if hp <= 0:
		die()
	else:
		on_hit()

func on_hit():
	effects.play("on_hit")

func attack():
	var arr = arrow.instance()
	arr.initialize(target, damage, arrow_speed, self.position)

func die():
	alive = false
	emit_signal("died", team)
	animation.stop()
	effects.play("die")

func destroy():
	#like die, but without an animation
	emit_signal("died", team)
	queue_free()
