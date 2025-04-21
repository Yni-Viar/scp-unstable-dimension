extends Node
## Made by Yni, licensed under MIT License.

## Stages of the developing
enum Stages {release, testing, dev}
enum ItemType {item, map_object, npc}

signal settings_saved

## Migrated from Globals.
## Game's data compatibility for modding.
const DATA_COMPATIBILITY: String = "1.0.0"
## Migrated from Globals.
## Game's data compatibility for modding.
const CURRENT_STAGE: Stages = Stages.dev
## If we don't specify regions, which have additional legal requirements, we are in trouble.
const LEGAL_REQ_REGIONS: PackedStringArray = ["ru_RU"]
## Touchscreen check
var touchscreen = false
## Settings resource
var setting_res: SettingsResource
## If we don't specify regions, which have additional legal requirements, we are in trouble.
var region: String = "":
	set(val):
		region = val
		legal_req = is_legal_req()
var legal_req: bool = false

func _init():
	load_resource()

## Sometimes ago it was a great function. Now it is just a stub, that calls ResourceStorage and loads settings
func load_resource():
	if OS.get_name() != "Web":
		var settings_from_file = ResourceStorage.load_resource("user://Settings.bin", "SettingsResource")
		if settings_from_file != null:
			setting_res = settings_from_file
		else:
			load_default_settings()
	else:
		load_default_settings()

func load_default_settings():
	if OS.get_name() != "Web":
		var res = load("res://Scripts/SettingsResource/Presets/OpenGL/Low.tres")
		save_resource(res)
		setting_res = res
	else:
		var res = load("res://Scripts/SettingsResource/Presets/OpenGL/Lowest.tres")
		save_resource(res)
		setting_res = res

## Sometimes ago it was a great function. Now it is just a stub, that calls ResourceStorage and saves settings
func save_resource(res):
	if OS.get_name() != "Web":
		ResourceStorage.save_resource("user://Settings.bin", res)
		emit_signal("settings_saved")

func is_legal_req() -> bool:
	return LEGAL_REQ_REGIONS.has(region)
