extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseMotion:
		rect_position = event.position + event.relative*2


#func _process(_delta):
#	rect_position = get_viewport().get_mouse_position()
