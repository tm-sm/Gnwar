extends CanvasLayer

func _ready():
	get_tree().paused = true

func _on_Exit_pressed():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/MainMenu.tscn")


func _on_Restart_pressed():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_Resume_pressed():
	resume()

func _input(event):
	if event.is_action_pressed("pause"):
		resume()

func resume():
	get_tree().paused = false
	queue_free()
