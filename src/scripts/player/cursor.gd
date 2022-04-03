extends TextureRect

export var t_small: Texture
export var t_large: Texture

var pixel_pos
var psize := 4
var cell_type = Cell.Id.FUNGUS
var large_mode := false

onready var draw = $"../CenterX/AlignTop/Draw"
onready var cells = draw.get_node("Cells")

func _ready():
	Global.connect("setting_changed", self, "_setting_changed")
	_setting_changed()

func _process(_delta):
	rect_size = 3 * Vector2(psize, psize)

	rect_position = snap_position(get_viewport().get_mouse_position() - Vector2(psize, psize))
	pixel_pos = screen_to_pixel(get_viewport().get_mouse_position())

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
		if pos_valid(pixel_pos):
			var new_type = cells.get_cell_id(pixel_pos[0], pixel_pos[1])
			if !(new_type in [Cell.Id.WALL, Cell.Id.AIR]):
				cell_type = new_type

	if Input.is_action_just_pressed("toggle_brush_size"):
		large_mode = !large_mode
		update_texture()

func update_texture():
	if large_mode:
		texture = t_large
	else:
		texture = t_small


func snap_position(screen_pos: Vector2) -> Vector2:
	var p = screen_to_pixel(screen_pos)
	p = Vector2(p[0], p[1])
	return p * psize + draw.rect_global_position


func screen_to_pixel(s_pos: Vector2) -> Array:
	var offset = draw.rect_global_position
	var px = int((s_pos.x - offset.x) / psize)
	var py = int((s_pos.y - offset.y) / psize)
	return [px, py]

func pos_valid(xy) -> bool:
	return xy[0] > 0 and xy[1] > 0 and xy[0] < draw.size[0] -1 and xy[1] < draw.size[1] -1

func _setting_changed():
	psize = Global.settings["pixel_size"]
