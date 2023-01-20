extends "res://Scripts/BaseEntity.gd"
class_name PatrollingAI

var target
var target_in_range

var patrol_area
var commander

var rest_position

var victory = false
var facing_right = true

func _ready():
	._ready()
	randomize()
	rest_position = randi() % 100
	target = commander.request_new_target()
	target_in_range = false
	
func initialize(comm, pos):
	commander = comm
	team = comm.team
	patrol_area = comm.get_patrol_area()
	comm.connect("target_entered", self, "_on_target_entered")
	comm.connect("target_exited", self, "_on_target_exited")
	position = pos


func _physics_process(_delta):
	velocity = Vector2.ZERO
	if not movement_blocked:
		if target_in_range:
			#actively in danger, attacking
			animPlayer.play("attack")
		elif target:
			#moving to target
			velocity = position.direction_to(target.position) * speed
			animPlayer.play("walking")
			move()
		elif patrol_area and not within_area_range():
			velocity = position.direction_to(patrol_area.global_position) * speed
			animPlayer.play("walking")
			move()
		elif victory:
			#no objectives, no targets
			play_animation_delayed("victory")
		else:
			animPlayer.play("idle")
		


func attack():
	#if the target left the range during the attack, nothing happens
	if target_in_range and target:
		target.recieve_damage(self)

func face_target():
	if target != null:
		if target.global_position.x - global_position.x < 0 and facing_right or target.global_position.x - global_position.x >= 0 and not facing_right:
			#on the left and facing right
			scale.x = -scale.x
			facing_right = not facing_right


func is_valid_target(body)->bool:
	if body and body.alive:
		return true
	else:
		return false


func set_target(body):
	target = body

func within_area_range()->bool:
	#to stop at a certain distance from the flag
	return abs(position.distance_to(patrol_area.global_position)) < rest_position


func _on_target_entered(body):
	if is_valid_target(body) and target == null:
		set_target(body)


func _on_target_exited(body):
	if body == target:
		target = null
		target_in_range = false
		target = commander.request_new_target()


func _on_AttackRange_body_entered(body):
	if body.team != team:
		#valid target checks this, but when all friendly unit bunch up this should improve performance a bit
		if body == target:
			target_in_range = true
		elif not target_in_range and is_valid_target(body):
			if target != null:
				target.disconnect("died", self, "_untarget")
			set_target(body)
			target_in_range = true


func _on_AttackRange_body_exited(body):
	if body == target:
		target_in_range = false


func play_animation_delayed(animation):
	var time = rand_range(.0, .7)
	yield(get_tree().create_timer(time), "timeout")
	animPlayer.play(animation)
