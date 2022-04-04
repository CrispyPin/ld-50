extends Cell
class_name GrassCell


var _col: Color
var landed := false
var tried_growing_up := false
var health := 50

func _init():
	self._col = Color(0.1,0.7,0.2)*rand_range(1.1,0.9)#Color(rand_range(0.6,0.8),rand_range(0.6,0.8),rand_range(0.4,0.6),1)

func getId():
	return Id.GRASS

func draw():
	return _col

func update(cells, light, x: int, y: int):
	Global.time_since_update["grass"] = 0
	if health == 0:
		cells.set_cell_id(x, y, Id.AIR)
		return
	if light[x][y] < randf():
		health -= 1

	var cell_below = cells.get_cell_id(x, y + 1)
	if !landed:
		if cell_below in [Id.AIR, Id.WATER]:
			cells.swap_cell(x, y, x, y + 1)
		elif is_ground(cell_below):
			landed = true
		return

	if light[x][y] < 0.5:
		return

	if !is_ground(cell_below):
		return

	var dx = randi()%3-1;

	if dx == 0 and !tried_growing_up:# grow straight up
		if randf() > 0.6:
			cells.set_cell_id(x, y-1, Id.GRASS)
		tried_growing_up = true
		return

	var adjacent = cells.get_cell_id(x + dx, y)
	var diagonal = cells.get_cell_id(x + dx, y + 1)
	var diagonal_up = cells.get_cell_id(x + dx, y - 1)

	if is_ground(adjacent) and diagonal_up == Id.AIR:# grow up diagonal
		cells.set_cell_id(x + dx, y - 1, Id.GRASS)

	elif is_ground(diagonal) and adjacent == Id.AIR:# grow sideways
		cells.set_cell_id(x + dx, y, Id.GRASS)

	elif diagonal == Id.AIR:# grow down diagonal
		cells.set_cell_id(x + dx, y + 1, Id.GRASS)
		var new = cells.get_cell(x+dx, y+1)
		new.landed = true

