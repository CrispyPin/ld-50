extends Cell
class_name FungusCell

const grow_offsets = [
	Vector2(-1, 0),
	Vector2(1, 0),
	Vector2(0, 1),
	Vector2(0, -1),
	#diagonals
	Vector2(-1, 1),
	Vector2(-1, -1),
	Vector2(1, 1),
	Vector2(1, -1),
]

var _col: Color
var landed := false

func _init():
	self._col = Color(0.6, 0.0, 1.0)*rand_range(1.1,0.9)#Color(rand_range(0.6,0.8),rand_range(0.6,0.8),rand_range(0.4,0.6),1)

func getId():
	return Id.FUNGUS

func draw():
#	return _col
	return Color(0,1,1)

func update(cells, light, x: int, y: int):
	if !landed:
		var cell_below = cells.get_cell_id(x, y + 1)
		if is_fluid(cell_below):
			cells.swap_cell(x, y, x, y + 1)
		elif is_ground(cell_below):
			landed = true
		return

	if light[x][y] > randf()*0.5 or randf() < 0.75:
		return

	var offset = grow_offsets[randi()%8]
	var target = cells.get_cell_id(x + offset.x, y + offset.y)
	if !is_fluid(target):
		return

	var surface = grow_offsets[randi()%4] + offset
	if !is_ground(cells.get_cell_id(x + surface.x, y + surface.y)):
		return

	cells.set_cell_id(x + offset.x, y + offset.y, Id.FUNGUS)
	var new = cells.get_cell(x + offset.x, y + offset.y)
	new.landed = true

