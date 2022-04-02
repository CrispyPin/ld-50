extends Cell


class_name TreeCell

var _col: Color

const grow_offsets = [[-1, 0] , [0, -1], [1, 0]]#, [0, 1]]

var tex_x = 0
var tex_y = 0
var landed = false
var pos_x = 0
var pos_y = 0

var twidth: int
var theight: int

func _init():
	twidth = Textures.t.tree_1.get_width()
	theight = Textures.t.tree_1.get_height()

func getId():
	return Id.TREE

func draw():
	return pixel(pos_x, pos_y)
#	return Color(1.0, 0.0, 1.0)
 
func pixel(x, y):
	return Textures.t.tree_1.get_pixel(tex_x, tex_y)

func update(cells, x: int, y: int):
	pos_x = x
	pos_y = y
	if landed:
		grow(cells, x, y)
		return
	
	tex_x = 6
	tex_y = theight-1
	# falling logic
	var cell_below = cells.get_cell_id(x, y + 1)
	if (cell_below == Id.AIR || cell_below == Id.WATER):
		cells.swap_cell(x, y, x, y+1)
	elif cell_below == Id.TREE:
		cells.set_cell(x, y, AirCell.new())
	else:
		landed = true
		
		
		#cells[x][y] = AirCell.new()   

func grow(cells, x: int, y: int):
	for delta in grow_offsets:
		var tx = delta[0] + x
		var ty = delta[1] + y
		
		var target_cell = cells.get_cell_id(tx, ty)
		if !(target_cell in [Id.AIR, Id.WATER]):
			continue
		
		if tex_y + delta[1] < 0 \
			or tex_y + delta[1] >= twidth \
			or tex_x + delta[0] >= theight \
			or tex_x + delta[0] >= theight:
				continue
#		if tx < tex_x:
#			print("cant grow left (x too small)")
#			continue
#
#		if tx - tex_x >= twidth:
#			print("cant grow right (x too big)")
#			continue
#		if ty < tex_y:
#			print("cant grow up (y too small)")
#			continue
#		if ty - tex_y >= theight:
#			print("cant grow down (y too big)")
#			print("target y:", ty, " texture root: ", tex_y, " ", theight)
#			continue
			
		var px = tx - tex_x
		var py = (ty - tex_y)
		#print(tx," ", ty," ", tex_x," ", tex_y," ", px," ", py)
#		44 29 15
#		45 29 16
#		44 29 15

		var pixel = pixel(tx, ty)
		if pixel.a == 0:
			return
		
		cells.set_cell_id(tx, ty, Id.TREE)
		var new = cells.get_cell(tx, ty)
		new.tex_x = tex_x + delta[0]
		new.tex_y = tex_y + delta[1]
		new.landed = true

