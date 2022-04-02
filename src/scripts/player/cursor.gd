extends TextureRect


var grid
var pixel_pos

func _ready():
	grid = $"../Draw"
	rect_size = Vector2(4, 4)
	rect_size *= 3

func _process(_delta):
	rect_position = snap_position(get_viewport().get_mouse_position()- Vector2(6,6), 4)
	pixel_pos = screen_to_pixel(get_viewport().get_mouse_position(), 4)


func snap_position(screen_pos: Vector2, grid_size) -> Vector2:
	return screen_to_pixel(screen_pos, grid_size) * grid_size

func screen_to_pixel(screen_pos: Vector2, grid_size) -> Vector2:
	var pos = screen_pos
	pos.x = int(pos.x / grid_size)
	pos.y = int(pos.y / grid_size)
	return pos
	
