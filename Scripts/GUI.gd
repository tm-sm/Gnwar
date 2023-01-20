extends CanvasLayer

onready var cinematics = $CinematicsPlayer

var skip = true

func play_cinematic(animation_name, skippable):
	cinematics.play(animation_name)
	skip = skippable

func clear_cinematic():
	 #in order to run all code snippets from the end of the animation
	cinematics.seek(cinematics.get_current_animation_length() - 0.01, false)

func _unhandled_input(event):
	if skip and Input.is_action_pressed("skip_cinematic"):
		clear_cinematic()

func get_cinematics_player()->AnimationPlayer:
	return cinematics
