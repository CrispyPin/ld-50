extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var t: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	t = {
		"debug": preload("res://textures/square.png").get_data(),
		"tree_1": preload("res://textures/tree-01.png").get_data(),
		"tree_2": preload("res://textures/tree-02.png").get_data(),
		"flower_1": preload("res://textures/flower-01.png").get_data(),
	}
	for key in t:
		t[key].lock()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
