extends Node

var setting_data : GameSettings
const setting_path := 'user://GameSettings.tres'

func _ready() -> void:
	if not FileAccess.file_exists(setting_path):
		setting_data = GameSettings.new()
	else:
		setting_data = load(setting_path)

func _exit_tree() -> void:
	ProjectSettings.save_custom('user://UserPreference.cfg')
	ResourceSaver.save(setting_data, setting_path)
