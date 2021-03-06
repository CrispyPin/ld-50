extends Node


export var game_scene = preload("res://scenes/Game.tscn")

var current_menu = "Main"


func _ready():
	set_menu("Main")
	if Global.INSTANT_START:
		call_deferred("start_game")


func _process(_delta):
	if Input.is_key_pressed(KEY_F5):
		start_game()

	if Input.is_action_just_pressed("game_menu") and Global.game_loaded:
		if current_menu == "No":
			open_game_menu()
		elif current_menu == "Game":
			close_game_menu()
		elif current_menu == "Settings":
			set_menu("Game")


func open_game_menu():
	set_menu("Game")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = Global.PAUSE_IN_MENU


func close_game_menu():
	set_menu()
	Input.set_mouse_mode(Global.CURSOR_MODE)
	get_tree().paused = false


func start_game():
	if Global.game_loaded:
		return
	Global.game_loaded = true
	var game = game_scene.instance()
	get_tree().root.add_child(game)
	get_tree().paused = false

	Input.set_mouse_mode(Global.CURSOR_MODE)
	set_menu()
	$Menus/SettingsMenu.update_menu()


func stop_game():
	if !Global.game_loaded:
		return
	Global.game_loaded = false
	get_node("/root/Game").queue_free()

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_menu("Main")
	$Menus/SettingsMenu.update_menu()


func set_menu(menu_name := "No"):
	for m in $Menus.get_children():
		var state = m.name == menu_name + "Menu"
		m.visible = state
	$Menus.visible = menu_name != "No"

	current_menu = menu_name
