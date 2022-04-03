extends Node


var t: Dictionary

func _ready():
	t = {
		"debug": preload("res://textures/square.png").get_data(),
		"tree_1": preload("res://textures/tree-01.png").get_data(),
		"tree_2": preload("res://textures/tree-02.png").get_data(),
		"flower_1": preload("res://textures/flower-01.png").get_data(),
	}
	for key in t:
		t[key].lock()
