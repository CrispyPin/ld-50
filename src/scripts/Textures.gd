extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var t: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	t = {
		"tree_1": preload("res://textures/tree-01.png").get_data(),
		"tree_2": preload("res://textures/tree-02.png").get_data(),
	}
	t["tree_1"].lock()
	t["tree_2"].lock()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
