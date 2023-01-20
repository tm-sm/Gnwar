extends Camera2D

#TODO fix wheelmovementsafezone and edgescrolling

export(float) var step = 10.0
export(float) var max_zoom = 0.1
export(float) var min_zoom = 1.5

var mouse_move_right = false
var mouse_move_left = false
var mouse_move_up = false
var mouse_move_down = false

var enabled
var move_towards_mouse = true

var restriction = Restriction
var normal_width
var normal_height

func initialize(restrict, crrnt, enbld):
	restriction = restrict
	current = crrnt
	enabled = enbld

func _ready():
	normal_width = get_viewport_rect().size.x / 2
	normal_height = get_viewport_rect().size.y / 2
	

func _process(delta):
	if enabled:
		
		var move = Vector2()
		
		#zoom
		if Input.is_action_just_released("zoom_in"):
			if zoom.x > max_zoom:
				zoom.x -= 0.03
				zoom.y -= 0.03
				if move_towards_mouse:
					move = move_towards_mouse()
		elif Input.is_action_just_released("zoom_out"):
			if zoom.x < min_zoom:
				zoom.x += 0.03
				zoom.y += 0.03
				if move_towards_mouse:
					move = -move_towards_mouse()
		
		#movement
		move += get_directional_input()
		move += get_mouse_movement_input()
		
		move_camera(move)

func move_towards_mouse()->Vector2:
	var mv = Vector2()
	mv.x = (get_global_mouse_position().x - position.x) / (step * 2)
	mv.y = (get_global_mouse_position().y - position.y) / (step * 2)
	return mv

func move_camera(dist):
	position.x += dist.x
	position.y += dist.y
	return_if_past_restriction()

func return_if_past_restriction():
	if position.x + (normal_width * zoom.x) > restriction.max_x:
		position.x = restriction.max_x - normal_width * zoom.x
	elif position.x - (normal_width * zoom.x) < restriction.min_x:
		position.x = restriction.min_x + normal_width * zoom.x
	if position.y + (normal_height * zoom.y) > restriction.max_y:
		position.y = restriction.max_y - normal_height * zoom.y
	elif position.y - (normal_height * zoom.x) < restriction.min_y:
		position.y = restriction.min_y + normal_height * zoom.y

func get_directional_input()->Vector2:
	var move = Vector2()
		
	if Input.is_action_pressed("move_camera_up"):
		move.y += -step
	if Input.is_action_pressed("move_camera_down"):
		move.y += step
	if Input.is_action_pressed("move_camera_right"):
		move.x += step
	if Input.is_action_pressed("move_camera_left"):
		move.x += -step
	
	return move

func get_mouse_movement_input()->Vector2:
	var move = Vector2()
	
	if mouse_move_right:
		move.x += step
	elif mouse_move_left:
		move.x -= step
	if mouse_move_up:
		move.y -= step
	elif mouse_move_down:
		move.y += step
	
	return move

func _on_Right_mouse_entered():
	mouse_move_right = true


func _on_Right_mouse_exited():
	mouse_move_right = false


func _on_Left_mouse_entered():
	mouse_move_left = true


func _on_Left_mouse_exited():
	mouse_move_left = false


func _on_Up_mouse_entered():
	mouse_move_up = true


func _on_Up_mouse_exited():
	mouse_move_up = false


func _on_Down_mouse_entered():
	mouse_move_down = true


func _on_Down_mouse_exited():
	mouse_move_down = false


func _on_WheelMovementSafeZone_mouse_entered():
	move_towards_mouse = false


func _on_WheelMovementSafeZone_mouse_exited():
	move_towards_mouse = true
