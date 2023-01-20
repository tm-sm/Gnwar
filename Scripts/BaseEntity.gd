extends KinematicBody2D
class_name BaseEntity

signal died(team)

export(bool) var movement_blocked: bool = false
var alive = true

export(Teams.team) var team
export(int) var hp_max: int = 100
export(int) var hp : int = hp_max
export(float) var defense: float = 0
export(int) var damage: int = 25

export(int) var speed: int = 75
var velocity: Vector2 = Vector2.ZERO

var rng = RandomNumberGenerator.new()

onready var animPlayer = $AnimationPlayer
onready var effects = $EntityEffects
onready var sprite = $body

func _ready():
	effects.play("empty")
	movement_blocked = false

func _physics_process(_delta):
	move()

func move():
	velocity = move_and_slide(velocity)

func attack():
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

func die():
	alive = false
	emit_signal("died", team)
	animPlayer.stop()
	effects.play("die")

func destroy():
	#like die, but without an animation
	emit_signal("died", team)
	queue_free()

func face_target():
	pass

func set_random_skin_color():
	rng.randomize()
	var skin_tone = rng.randf_range(0.30, 0.9)
	sprite.skin.modulate = Color.from_hsv(1.0/2.9, 0.35, skin_tone)
