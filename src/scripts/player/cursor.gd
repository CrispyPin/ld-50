extends TextureRect

signal type_changed

export var t_small: Texture
export var t_large: Texture

var pixel_pos
var psize := 4
var cell_type = Cell.Id.STONE setget set_type
var large_mode := false

var audio_nodes := {}
var audio_times := {}
var audio_lengths := {}


onready var draw = $"../CenterX/AlignTop/Draw"
onready var cells = draw.get_node("Cells")

func _ready():
	Global.connect("setting_changed", self, "_setting_changed")
	_setting_changed()
	audio_nodes = {
		"default": $Audio/Pop,
		Cell.Id.STONE: $Audio/Knock,
		Cell.Id.FISH: $Audio/LowPop,
		Cell.Id.BIRD: $Audio/LowPop,
		Cell.Id.WORM: $Audio/LowPop,
		Cell.Id.AIR: $Audio/Woosh,
		Cell.Id.SMOKE: $Audio/Woosh,
		Cell.Id.SAND: $Audio/Sand,
		Cell.Id.FIRE: $Audio/Snap,
	}
	for node in $Audio.get_children():
		audio_times[node] = 0
	audio_lengths = {
		$Audio/Pop: 2,
		$Audio/LowPop: 3,
		$Audio/Knock: 3,
		$Audio/Woosh: 6,
		$Audio/Sand: 5,
		$Audio/Snap: 2,
	}

func _process(_delta):
	rect_size = 3 * Vector2(psize, psize)

	rect_position = snap_position(get_viewport().get_mouse_position() - Vector2(psize, psize))
	pixel_pos = screen_to_pixel(get_viewport().get_mouse_position())

	if Input.get_mouse_button_mask() == BUTTON_LEFT:
		if large_mode:
			for x in range(-1,2):
				for y in range(-1,2):
					var xy = [pixel_pos[0]+x, pixel_pos[1]+y]
					var any = false
					if pos_valid(xy):
						if place_cell(xy[0], xy[1]):
							any = true
					if any:
						play_sound()
		else:
			if pos_valid(pixel_pos):
				if place_cell(pixel_pos[0], pixel_pos[1]):
					play_sound()

	elif Input.get_mouse_button_mask() == BUTTON_RIGHT:
		if pos_valid(pixel_pos):
			var new_type = cells.get_cell_id(pixel_pos[0], pixel_pos[1])
			if !(new_type in [Cell.Id.WALL, Cell.Id.AIR]):
				set_type(new_type)

	if Input.is_action_just_pressed("toggle_brush_size"):
		large_mode = !large_mode
		update_texture()

	if Input.is_action_just_pressed("next_celltype"):
		set_type(cell_type + 1)
	if Input.is_action_just_pressed("prev_celltype"):
		set_type(cell_type - 1)

	for n in audio_times:
		audio_times[n] += 1

# returns wether anything changed
func place_cell(x, y) -> bool:
	if !(cell_type in Cell.Id.values()):
		return false
	var old = cells.get_cell_id(x, y)
	if old != cell_type:
		cells.set_cell_id(x, y, cell_type)
		return true
	return false

func play_sound():
	var n = get_audio_node()
#	n.play()
	# audio must play at least a few frames before restarting
	if audio_times[n] >= audio_lengths[n]:
		n.play()
		audio_times[n] = 0
#	if !n.playing:
#		n.playing = true

func get_audio_node():
	if cell_type in audio_nodes:
		return audio_nodes[cell_type]
	return audio_nodes["default"]

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

func set_type(new):
	cell_type = new
	emit_signal("type_changed")

func pos_valid(xy) -> bool:
	return xy[0] > 0 and xy[1] > 0 and xy[0] < draw.size[0] -1 and xy[1] < draw.size[1] -1

func _setting_changed():
	psize = Global.settings["pixel_size"]
