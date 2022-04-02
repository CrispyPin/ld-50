extends Cell
class_name TreeCell

var grow_offsets = [[0, -1], [-1, 0], [1, 0], [0, 1]]

var tex_x = 0
var tex_y = 0
var landed = false

var t_width: int
var t_height: int

func _init():
	t_width = Textures.t.tree_1.get_width()
	t_height = Textures.t.tree_1.get_height()
	tex_x = 6
	tex_y = t_height - 1
	grow_offsets.shuffle()

func getId():
	return Id.TREE

func draw():
	return Textures.t.tree_1.get_pixel(tex_x, tex_y)
#	return Color(tex_x/16.0, tex_y/16.0, 1.0)
#	return Color(1.0, 0.0, 1.0)

func update(cells, light, x: int, y: int):
	if landed:
		if grow_offsets:
			grow(cells, light, x, y)
		return

	# falling logic
	var cell_below = cells.get_cell_id(x, y + 1)
	if cell_below in [Id.SAND]:
		landed = true
	elif cell_below == Id.TREE:
		cells.set_cell(x, y, AirCell.new())
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
	var pixel = Textures.t.tree_1.get_pixel(tex_x + dx, tex_y + dy)
	if pixel.a == 0:
		return
	
	# check if target location is free
	var target_cell = cells.get_cell_id(target_x, target_y)
	if !(target_cell in [Id.AIR]):
		return
	
	cells.set_cell_id(target_x, target_y, Id.TREE)

	var new = cells.get_cell(target_x, target_y)
	if new.getId() != Id.TREE:
		return # setting the cell to tree failed for some reason
	new.tex_x = tex_x + dx
	new.tex_y = tex_y + dy
	new.landed = true

