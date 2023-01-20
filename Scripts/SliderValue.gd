extends Label

export(String) var slider_name = ""
onready var slider

func _ready():
	slider = get_node("../" + slider_name)
	slider.connect("value_changed", self, "_on_value_changed")
	text = str(slider.value)

func _on_value_changed(value):
	text = str(value)
