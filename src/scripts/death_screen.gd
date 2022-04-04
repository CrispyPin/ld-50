extends Control

var has_died := false

func _ready():
	visible = false


func _process(_delta):
	if has_died:
		return
	if false in Global.species_alive.values():
		has_died = true
		visible = true


func _on_Exit_pressed():
	UI.stop_game()


func _on_Continue_pressed():
	visible = false
