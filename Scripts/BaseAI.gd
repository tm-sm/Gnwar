extends "res://Scripts/BaseEntity.gd"
class_name BaseAI

var target
var target_in_range

var objective
var commander
var order

var victory = false
var facing_right = true

onready var detect_range = $DetectionRange

func _ready():
	._ready()
	target = null
	target_in_range = false

func initialize(comm, obj, ordr, pos):
	commander = comm
	team = commander.team
	set_objective(obj)
	global_position = pos
	order = ordr


func _physics_process(_delta):
	velocity = Vector2.ZERO
	if not movement_blocked:
		if target_in_range:
			#actively in danger, attacking
			animPlayer.play("attack")
		elif order and order.active:
			velocity = global_position.direction_to(order.global_position) * speed
			animPlayer.play("walking")
			move()
		elif target:
			#moving to target
			velocity = global_position.direction_to(target.global_position) * speed
			animPlayer.play("walking")
			move()
		elif objective and objective.active:
			#not attacking, heading to objective
			velocity = global_position.direction_to(objective.global_position) * speed
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

func set_objective(obj):
	objective = obj
	if objective:
		#in case there are no more objectives
		objective.connect("destroyed", self, "_request_new_objective")


func _request_new_objective():
	if commander:
		set_objective(commander.get_random_objective())
	if not objective:
		victory = true


func is_valid_target(body)->bool:
	if body and body.alive and body.team != team:
		return true
	else:
		return false


func set_target(body):
	target = body
	if target:
		#in case the target set was null
		target.connect("died", self, "_untarget")


func _on_DetectionRange_body_entered(body):
	if is_valid_target(body) and target == null:
		set_target(body)


func _on_DetectionRange_body_exited(body):
	if body == target:
		target = null


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


func _untarget(team):
	
	#untargets and checks if there are any other enemies nearby
	var entities = detect_range.get_overlapping_bodies()
	entities.erase(target)
	entities.erase(self)
	#to prevent attacking itself
	target_in_range = false
	
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

func play_animation_delayed(animation):
	var time = rand_range(.0, .7)
	yield(get_tree().create_timer(time), "timeout")
	animPlayer.play(animation)
