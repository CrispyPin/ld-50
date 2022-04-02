extends TextureRect

signal place_cell


var pixel_pos
var cell_type = Cell.Id.TREE

onready var grid = $"../Draw"
onready var cells = $"../Draw/Cells"

func _ready():
	rect_size = Vector2(4, 4)
	rect_size *= 3

func _process(_delta):
	rect_position = snap_position(get_viewport().get_mouse_position() - Vector2(4,4), 4)
	pixel_pos = screen_to_pixel(get_viewport().get_mouse_position(), 4)
	if Input.get_mouse_button_mask() == BUTTON_LEFT:
		cells.set_cell_id(pixel_pos[0], pixel_pos[1], cell_type)
		


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT && event.pressed:
			cell_type = cells.get_cell_id(pixel_pos[0], pixel_pos[1])


func snap_position(screen_pos: Vector2, grid_size) -> Vector2:
	var p = screen_to_pixel(screen_pos, grid_size)
	p = Vector2(p[0], p[1])
	return p * grid_size


func screen_to_pixel(pos: Vector2, grid_size) -> Array:
	return [int(pos.x / grid_size), int(pos.y / grid_size)]
	
