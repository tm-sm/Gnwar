extends Position2D
class_name SimpleProjectile

var team = null
var alive = false

onready var animation = $AnimationPlayer
onready var sprite = $Sprite

export(int) var damage = 50
export(int) var speed = 450
var velocity: Vector2 = Vector2.ZERO

var angle_offset = -0.785398 #45 degrees

var target
#fixed point in space, Vector2
var direction

var moving = false

func _ready():
	animation.play("flying")
	var distance_to_target = target - global_position
	target = global_position + distance_to_target * 1.2
	rotation = global_position.angle_to_point(target) + angle_offset

func _physics_process(delta):
	if reached_target():
		moving = false
	if moving and target != null:
		global_position = global_position.move_toward(target, delta * speed)

func initialize(trgt, dmg, spd, pos, tm):
	damage = dmg
	speed = spd
	global_position = pos
	target = trgt
	team = tm
	

func fire():
	moving = true

func reached_target()->bool:
	if abs(global_position.distance_to(target)) < 10:
		animation.play("despawn")
		return true
	return false

func _on_HitBox_body_entered(body):
	if body.team != team and body.alive:
		body.recieve_damage(self)
		queue_free()
