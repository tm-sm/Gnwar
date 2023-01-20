extends Control

onready var anim = $CinematicPlayer
onready var start_exit_panel = $StartExit
onready var level_picker = $LevelPicker

onready var wave_survival_button = $LevelPicker/WaveSurvival
onready var ai_v_ai_button = $LevelPicker/AivAI

func _ready():
	level_picker.hide()
	anim.play_cinematic("logo_idle", false)

func _on_Start_pressed():
	start_exit_panel.hide()
	level_picker.show()
	anim.play_cinematic("fade_to_black", true)


func _on_Exit_pressed():
	get_tree().quit()


func _start_AIvAI():
	ai_v_ai_button.disabled = true
	get_tree().change_scene("res://Levels/AIvAI.tscn")

func _start_WaveSurvival():
	wave_survival_button.disabled = true
	get_tree().change_scene("res://Levels/WaveSurvival.tscn")


func _on_WaveSurvival_pressed():
	
	anim.play_cinematic("fade_to_black_WaveSurvival", true)


func _on_AivAI_pressed():
	anim.play_cinematic("fade_to_black_AIvAI", true)


func _on_Back_pressed():
	level_picker.hide()
	start_exit_panel.show()
	
