extends Node2D

signal good_victory
signal evil_victory
#this is ugly and should be changed

onready var gnome_obj = $Gnome
onready var anti_gnome_obj = $AntiGnome

func _ready():
	#this is ALSO ugly and should be changed
	gnome_obj.connect("all_objectives_destroyed", self, "_evil_victory")
	anti_gnome_obj.connect("all_objectives_destroyed", self, "_good_victory")

func get_gnome_objectives()->TeamObjectiveManager:
	return gnome_obj

func get_anti_gnome_objectives()->TeamObjectiveManager:
	return anti_gnome_obj

func _good_victory():
	emit_signal("good_victory")

func _evil_victory():
	emit_signal("evil_victory")
