extends CanvasLayer

export(String) var text 

onready var label = $Rows/Label

func _ready():
	label.text = text

func _on_Restart_pressed():
	get_tree().reload_current_scene()


func _on_Exit_pressed():
	get_tree().change_scene("res://UI/MainMenu.tscn")
