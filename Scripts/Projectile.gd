extends Position2D
class_name TrackingProjectile

var team = null
var alive = false

onready var animation = $AnimationPlayer
onready var sprite = $Sprite

export(int) var damage = 50
export(int) var speed = 450
var velocity: Vector2 = Vector2.ZERO

var angle_offset = -0.785398 #45 degrees

var target
var direction

var moving = false

func _ready():
	pass

func _physics_process(delta):
	if moving and target != null:
		var sprite_pos = sprite.global_position
		sprite.rotation = sprite_pos.angle_to_point(target.global_position) + angle_offset
		global_position = global_position.move_toward(target.global_position, delta * speed)

func initialize(trgt, dmg, spd, pos):
	target = trgt
	damage = dmg
	speed = spd
	position = pos

func fire():
	moving = true

func _on_HitBox_body_entered(body):
	if body == target:
		target.recieve_damage(self)
		queue_free()

func _untarget(team):
	queue_free()
