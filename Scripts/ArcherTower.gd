extends KinematicBody2D
class_name ArcherTower

onready var effects = $StructureEffects
onready var animation = $AnimationPlayer
onready var sprite = $Sprite
onready var gnome_sprite = $Sprite/GnomeArcher
onready var detect_range = $DetectionRange

var arrow = preload("res://Entities/projectiles/SimpleProjectile.tscn")

export(Teams.team) var team
export(int) var hp_max: int = 500
export(int) var hp : int = hp_max
export(float) var defense: float = 0
export(int) var damage = 50
export(int) var arrow_speed = 450

var alive = true

var target
var world

func _ready():
	pass

func initialize(wrld, tm):
	world = wrld
	team = tm

func _physics_process(delta):
	if target:
		animation.play("attack")
	else:
		animation.play("idle")

func recieve_damage(entity):
	var reduction = entity.damage * defense
	hp -= entity.damage - reduction
	if hp <= 0:
		destroy()
	else:
		on_hit()

func on_hit():
	effects.play("on_hit")

func set_target(body):
	target = body
	if target:
		#in case the target set was null
		target.connect("died", self, "_untarget")

func is_valid_target(body)->bool:
	if body and body.team != team and body.alive:
		return true
	else:
		return false

func attack():
	if target:
		var arr = arrow.instance()
		arr.initialize(target.global_position, damage, arrow_speed, gnome_sprite.global_position, team)
		world.add_child(arr)
		arr.fire()

func die():
	alive = false
	emit_signal("died", team)
	animation.stop()
	effects.play("die")

func destroy():
	#like die, but without an animation
	alive = false
	emit_signal("died", team)
	queue_free()


func _on_DetectionRange_body_entered(body):
	if is_valid_target(body) and target == null:
		set_target(body)

func _untarget(team):

	#untargets and checks if there are any other enemies nearby
	var entities = detect_range.get_overlapping_bodies()
	entities.erase(target)
	entities.erase(self)
	
	#this prevents the previous target from appearing as the closest target
	target = null

	if entities.size() > 0:
		var nearest_entity
		for entity in entities:
			if is_valid_target(entity):
				if nearest_entity == null:
					#in order to set up the first entity
					nearest_entity = entity
				if entity.global_position.distance_to(global_position) < nearest_entity.global_position.distance_to(global_position):
					nearest_entity = entity
		set_target(nearest_entity)


func _on_DetectionRange_body_exited(body):
	if body == target:
		target = null
