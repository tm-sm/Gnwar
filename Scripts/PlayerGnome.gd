extends "res://Scripts/BaseEntity.gd"
class_name PlayerGnome

func _physics_process(delta):
	var input_dir = get_input_direction()
	
	if input_dir != Vector2.ZERO and not movement_blocked:
		#player is moving
		velocity = speed * input_dir
		animPlayer.play("walking")
	else:
		#idle
		animPlayer.play("idle")
		velocity = Vector2.ZERO
	
	move()

func move():
	velocity = move_and_slide(velocity)


func get_input_direction() -> Vector2:
	var input_dir = Vector2.ZERO
	
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_dir = input_dir.normalized()
	
	return input_dir
