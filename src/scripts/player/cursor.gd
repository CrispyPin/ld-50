extends TextureRect

var pixel_pos
var cell_type = Cell.Id.FIRE
var large_mode := false

onready var draw = $"../Draw"
onready var cells = $"../Draw/Cells"

func _ready():
	pass

func _process(_delta):
	var psize = Vector2(1, 1) * Global.settings["pixel_size"]
	rect_size = 3 * psize
	
	rect_position = snap_position(get_viewport().get_mouse_position() - psize, psize.x)
	pixel_pos = screen_to_pixel(get_viewport().get_mouse_position(), psize.x)
	
	if Input.get_mouse_button_mask() == BUTTON_LEFT:
		if large_mode:
			for x in range(-1,2):
				for y in range(-1,2):
					var xy = [pixel_pos[0]+x, pixel_pos[1]+y]
					if pos_valid(xy):
						cells.set_cell_id(xy[0], xy[1], cell_type)
		else:
			if pos_valid(pixel_pos):
				cells.set_cell_id(pixel_pos[0], pixel_pos[1], cell_type)
	
	elif Input.get_mouse_button_mask() == BUTTON_RIGHT:
		cell_type = cells.get_cell_id(pixel_pos[0], pixel_pos[1])
		if cell_type == Cell.Id.WALL:
			cell_type = Cell.Id.STONE

	if Input.is_action_just_pressed("toggle_brush_size"):
		large_mode = !large_mode

func snap_position(screen_pos: Vector2, grid_size) -> Vector2:
	var p = screen_to_pixel(screen_pos, grid_size)
	p = Vector2(p[0], p[1])
	return p * grid_size


func screen_to_pixel(pos: Vector2, grid_size) -> Array:
	return [int(pos.x / grid_size), int(pos.y / grid_size)]

func pos_valid(xy) -> bool:
	return xy[0] > 0 and xy[1] > 0 and xy[0] < draw.size[0] -1 and xy[1] < draw.size[1] -1
