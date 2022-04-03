extends Node

const PAUSE_IN_MENU  = true
const CURSOR_MODE = Input.MOUSE_MODE_HIDDEN
const INSTANT_START = true


const DEBUG_SETTINGS = true
const SETTINGS_PATH = "user://settings.json"
const SETTINGS_DEF = {
	"update_rate": {
		"name": "Update Rate",
		"flags": [],
		"type": "number",
		"default": 20,
		"min": 1,
		"max": 100,
		"step": 5,
	},
#	"example_toggle": {
#		"name": "Toggle (main menu)",
#		"flags": ["main_menu_only"],
#		"tooltip": "tooltip here",
#		"type": "toggle",
#		"default": false
#	},
#	"example_toggle2": {
#		"name": "Toggle",
#		"flags": [],
#		"type": "toggle",
#		"default": false
#	},
#	"example_toggle5": {
#		"name": "Toggle (main menu)",
#		"flags": ["main_menu_only"],
#		"type": "toggle",
#		"default": false
#	},
#	"example_number": {
#		"name": "Number setting",
#		"flags": [],
#		"type": "number",
#		"default": 420,
#		"min": 400,
#		"max": 500,
#		"step": 1#optional
#	},
#	"example_choice": {
#		"name": "Dropdown: ",
#		"flags": [],
#		"type": "choice",
#		"default": 1,
#		"options": ["Option A", "Option B", "Option C"]
#	}
}

var game_loaded = false
var settings_loaded = false
var paused = false
var settings = {}


func _ready() -> void:
	_init_settings()
	load_settings()
	settings_loaded = true


func set_setting(key, val):
	settings[key] = val
	if DEBUG_SETTINGS:
		print("Settings changed. ", key, ": ", val)
	save_settings()


func _init_settings():
	for key in SETTINGS_DEF:
		settings[key] = SETTINGS_DEF[key].default
	if DEBUG_SETTINGS:
		print("Default settings: ", settings)


func save_settings():
	var file = File.new()
	file.open(SETTINGS_PATH, File.WRITE)
	file.store_line(to_json(settings))
	file.close()


func load_settings() -> void:
	var file = File.new()

	if not file.file_exists(SETTINGS_PATH):
		if DEBUG_SETTINGS:
			print("No settings file exists, using defaults")
		return

	file.open(SETTINGS_PATH, File.READ)
	var new_settings = parse_json(file.get_as_text())
	file.close()

	# in case settings format has changed, this is better than just copying
	for key in new_settings:
		if settings.has(key):
			settings[key] = new_settings[key]
	save_settings()
	if DEBUG_SETTINGS:
		print("Loaded settings from file")
		print(settings)
