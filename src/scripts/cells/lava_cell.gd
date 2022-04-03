extends Cell
class_name LavaCell

const offsets = [
	[-1, 0],
	[1, 0],
	[0, 1],
	[0, -1],
]

var _col: Color

func _init():
	self._col = Color(1.0,0.4,0.0) * rand_range(0.9,1.1)

func getId():
	return Id.LAVA

func draw():
	return _col
 
func update(cells, _light, x: int, y: int):

	
	var dx = randi()%3-1;
	var dy = 1
	if dx != 0:
		dy = 0
		
	var px = x + dx
	var py = y + dy
	
	var neighborcell = cells.get_cell_id(px,py)
	
	if is_gas(neighborcell):
		cells.swap_cell(x, y, px, py)
	
	var solidify = false
	for dir in offsets:
		var tx = x + dir[0]
		var ty = y + dir[1]
		var neighbor = cells.get_cell_id(tx, ty)
		if neighbor == Id.WATER:
			cells.set_cell_id(tx, ty, Id.SMOKE)
			solidify = true
		elif is_flammable(neighbor):
			cells.set_cell_id(tx, ty, Id.FIRE)
			
	if solidify:
		cells.set_cell_id(x, y, Id.STONE)
