extends AnimationPlayer

var skip = true

func play_cinematic(animation_name, skippable):
	play(animation_name)
	skip = skippable

func clear_cinematic():
	 #in order to run all code snippets from the end of the animation
	seek(get_current_animation_length() - 0.01, false)

func _unhandled_input(event):
	if skip and Input.is_action_pressed("skip_cinematic"):
		clear_cinematic()
