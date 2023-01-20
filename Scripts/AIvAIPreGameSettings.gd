extends CanvasLayer

onready var g_str_slider = $GnomeOptions/Options/StrengthSlider
onready var ag_str_slider = $AntiGnomeOptions/Options/StrengthSlider

onready var gb_hp_slider = $GnomeOptions/Options/ObjHPSlider
onready var agb_hp_slider = $AntiGnomeOptions/Options/ObjHPSlider

signal start_pressed(g_strength, ag_strength, g_base_hp, ag_base_hp)

func _on_Button_pressed():
	var g_str = g_str_slider.value
	var ag_str = ag_str_slider.value
	var gb_hp = gb_hp_slider.value
	var agb_hp = agb_hp_slider.value
	emit_signal("start_pressed", g_str, ag_str, gb_hp, agb_hp)
	queue_free()


func _on_Back_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/MainMenu.tscn")
