extends Node

var food_packages : Array[PackedScene] = []

func _ready() -> void:
	var dir := DirAccess.open("res://Food/")
	for folder in dir.get_directories():
		for file in dir.get_files_at(folder):
			if file.ends_with('.tscn'):
				food_packages.append(load(file))
