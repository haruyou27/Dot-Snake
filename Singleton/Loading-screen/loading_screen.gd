extends Control

const mod_folder := 'user://Mods'
@onready var mod_list :PackedStringArray = UserConfigure.setting_data.mod_list

func _ready():
	# Load mods.
	
	if not DirAccess.dir_exists_absolute(mod_folder):
		DirAccess.make_dir_absolute(mod_folder)
		return
		
	var new_mod_list = DirAccess.open(mod_folder).get_files()
	var index := 0
	for mod in new_mod_list.duplicate():
		if not mod.ends_with('.pck'):
			new_mod_list.remove_at(0)
		else:
			index += 1
			# Do not break old mod list load order !
			if not mod_list.has(mod):
				mod_list.append(mod)
	
	index = 0
	for mod in mod_list.duplicate():
		# Check if mod is removed.
		if new_mod_list.has(mod):
			ProjectSettings.load_resource_pack(mod)
			index += 1
		else:
			mod_list.remove_at(index)
