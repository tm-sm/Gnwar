extends CanvasLayer


func _on_Restart_pressed():
	get_tree().reload_current_scene()


func _on_Exit_pressed():
	get_tree().change_scene("res://UI/MainMenu.tscn")
