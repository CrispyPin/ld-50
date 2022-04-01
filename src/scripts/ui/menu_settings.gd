extends Control


var has_initialised = false

var _toggle_setting = preload("res://scenes/ui/menu_items/ButtonToggle.tscn")
var _number_setting = preload("res://scenes/ui/menu_items/NumberSetting.tscn")
var _dropdown_setting = preload("res://scenes/ui/menu_items/DropdownSetting.tscn")
var _main_menu_only = []

onready var _container = get_node("PanelContainer/VSplitContainer/ScrollContainer/MarginContainer/VBoxContainer")


func _process(_delta) -> void:
	if Global.settings_loaded and !has_initialised:
		create_menu()
		has_initialised = true


func update_menu():
	for i in _main_menu_only:
		i.disabled = Global.game_loaded


func create_menu():
	for s_key in Global.SETTINGS_DEF:
		var s_prop = Global.SETTINGS_DEF[s_key]
		var new_item
		var btn

		if s_prop.type == "toggle":
			new_item = _add_toggle(s_key, s_prop)
			btn = new_item.get_child(0)
		elif s_prop.type == "number":
			new_item = _add_number(s_key, s_prop)
			btn = new_item.get_node("HSplitContainer/SpinBox")
		elif s_prop.type == "choice":
			new_item = _add_option(s_key, s_prop)
			btn = new_item.get_child(0)

		if "main_menu_only" in s_prop.flags:
			_main_menu_only.append(btn)
		if s_prop.has("tooltip"):
			btn.hint_tooltip = s_prop.tooltip

		_container.add_child(new_item)
		_container.move_child(new_item, _container.get_child_count()-2)


func _add_toggle(name, properties):
	var item = _toggle_setting.instance()
	var btn = item.get_child(0)
	btn.connect("pressed", self, "_on_toggle_changed", [name])

	item.name = name
	btn.text = properties.name
	btn.pressed = Global.settings[name]
	return item


func _add_number(name, properties):
	var item = _number_setting.instance()
	var spinbox = item.get_child(0).get_child(1)
	spinbox.connect("value_changed", self, "_on_number_changed", [name])

	item.name = name
	spinbox.min_value = properties.min
	spinbox.max_value = properties.max
	spinbox.value = Global.settings[name]
	if properties.has("step"):
		spinbox.step = properties.step
	item.get_child(0).get_child(0).get_child(0).text = properties.name
	return item


func _add_option(name, properties):
	var item = _dropdown_setting.instance()
	var btn = item.get_child(0)
	btn.connect("item_selected", self, "_on_option_changed", [name])

	for i in properties.options:
		btn.add_item(properties.name + i)
	btn.selected = Global.settings[name]

	item.name = name
	return item


func _on_toggle_changed(name):
	var state = _container.get_node(name).get_child(0).pressed
	Global.set_setting(name, state)


func _on_number_changed(val, name):
	Global.set_setting(name, val)


func _on_option_changed(val, name):
	Global.set_setting(name, val)


func _on_BackButton_pressed() -> void:
	if Global.game_loaded:
		UI.set_menu("Game")
	else:
		UI.set_menu("Main")
