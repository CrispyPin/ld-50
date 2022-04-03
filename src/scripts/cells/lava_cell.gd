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
		return

	var solidify = false
	#for dir in offsets:
	var dir = offsets[randi()%offsets.size()]
	if true:
		var tx = x + dir[0]
		var ty = y + dir[1]
		var neighbor = cells.get_cell_id(tx, ty)
		if is_moist(neighbor):
			cells.set_cell_id(tx, ty, Id.SMOKE)
			solidify = true
		elif is_flammable(neighbor):
			cells.set_cell_id(tx, ty, Id.FIRE)
		elif (neighbor == Id.STONE || neighbor == Id.SAND) && rand_range(0,1)> 0.995:#(0.999 if dir[1]<0 else (0.99 if dir[1]==0 else 0.9)):
			cells.set_cell_id(tx, ty, Id.LAVA)

	if solidify:
		if randf()>0.1:
			cells.set_cell_id(x, y, Id.STONE)
		else:
			cells.set_cell_id(x, y, Id.AIR)

