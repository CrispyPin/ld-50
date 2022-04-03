extends Cell
class_name PlantCell

const type_ids = {
	"tree_1": Id.TREE_1,
	"tree_2": Id.TREE_2,
	"flower_1": Id.FLOWER_1,
}
const x_offsets = {
	"tree_1": 6,
	"tree_2": 7,
	"flower_1": 3,
}

# texture pixel coords
var tex_x = 0
var tex_y = 0
var landed = false
var grow_offsets = [[0, -1], [-1, 0], [1, 0], [0, 1]]

var type := "tree_1" setget set_type
var t_width: int
var t_height: int

func _init():
	set_type(type)
	grow_offsets.shuffle()

func set_type(new):
	type = new
	t_width = Textures.t[type].get_width()
	t_height = Textures.t[type].get_height()
	tex_x = x_offsets[type]
	tex_y = t_height - 1
	

func getId():
	return type_ids[type]

func draw():
	return Textures.t[type].get_pixel(tex_x, tex_y)
#	return Color(tex_x/16.0, tex_y/16.0, 1.0)
#	return Color(1.0, 0.0, 1.0)

func update(cells, light, x: int, y: int):
	if landed:
		if grow_offsets:
			grow(cells, light, x, y)
		return

	# falling logic
	var cell_below = cells.get_cell_id(x, y + 1)
	if is_ground(cell_below):
		landed = true
	elif is_plant(cell_below):
		cells.set_cell(x, y, AirCell.new())
	elif cell_below == Id.GRASS:
		cells.set_cell(x, y, AirCell.new())
		cells.set_cell_id(x, y+1, type_ids[type])
	else:
		cells.swap_cell(x, y, x, y+1)


func grow(cells, _light, x: int, y: int):
	var delta = grow_offsets.pop_front()
	var dx = delta[0]
	var dy = delta[1]
	var target_x = x + dx
	var target_y = y + dy
	
	# check if in bounds of texture
	if tex_y + dy < 0 \
		or tex_y + dy >= t_width \
		or tex_x + dx >= t_height \
		or tex_x + dx < 0:
			return
	
	# check if texture has cells there
	var pixel = Textures.t[type].get_pixel(tex_x + dx, tex_y + dy)
	if pixel.a == 0:
		return
	
	# check if target location is free
	var target_cell = cells.get_cell_id(target_x, target_y)
	if !(target_cell in [Id.AIR]):
		return
	
	cells.set_cell_id(target_x, target_y, type_ids[type], {
		"tex_x": tex_x + dx,
		"tex_y": tex_y + dy,
		"landed": true,
		"type": type,
		})

