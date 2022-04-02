extends Cell


class_name TreeCell

var _col: Color

const grow_offsets = [[-1, 0] , [0, -1], [1, 0], [0, 1]]

var tex_x = 0
var tex_y = 0
var landed = false
var pos_x = 0
var pos_y = 0
var grown_cells = 0

var twidth: int
var theight: int

func _init():
	twidth = Textures.t.tree_1.get_width()
	theight = Textures.t.tree_1.get_height()
	tex_x = 6
	tex_y = theight-1

func getId():
	return Id.TREE

func draw():
	return Textures.t.tree_1.get_pixel(tex_x, tex_y)
#	return Color(tex_x/16.0, tex_y/16.0, 1.0)
#	return Color(1.0, 0.0, 1.0)

func update(cells, light, x: int, y: int):
	if landed:
		if grown_cells < 3:
			grow(cells, light, x, y)
		return
	pos_x = x
	pos_y = y
	# falling logic
	var cell_below = cells.get_cell_id(x, y + 1)
	if cell_below in [Id.SAND]:
		landed = true
	elif cell_below == Id.TREE:
		cells.set_cell(x, y, AirCell.new())
	else:
		cells.swap_cell(x, y, x, y+1)
		

func grow(cells, light, x: int, y: int):
	for delta in grow_offsets:
		var tx = delta[0] + x
		var ty = delta[1] + y
		
		# check if in bounds of texture
		if tex_y + delta[1] < 0 \
			or tex_y + delta[1] >= twidth \
			or tex_x + delta[0] >= theight \
			or tex_x + delta[0] < 0:
				continue
		
		# this was a valid attempt
		grown_cells += 1
		# check if texture has cells there
#		var pixel = pixel(delta[0], delta[1])
		var pixel = Textures.t.tree_1.get_pixel(tex_x + delta[0], tex_y + delta[1])
		if pixel.a == 0:
			continue
		
		# check if target location is free
		var target_cell = cells.get_cell_id(tx, ty)
		if !(target_cell in [Id.AIR, Id.WATER]):
			continue
		
		cells.set_cell_id(tx, ty, Id.TREE)
		var new = cells.get_cell(tx, ty)
		if new.getId() != Id.TREE:
			continue # setting the cell to tree failed for some reason
		new.tex_x = tex_x + delta[0]
		new.tex_y = tex_y + delta[1]
		new.landed = true
		
