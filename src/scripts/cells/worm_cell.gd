extends Cell
class_name WormCell

var directions = [
	[-1, 0],
	[1, 0],
	[0, 1],
	[0, -1],
]

var _col: Color
var next_segment = [0,0]
var is_head := true
var still_time := 0

func _init():
	self._col = Color(1.0, 0.6, 0.5)*rand_range(0.8, 1.0)

func kill(cells, x, y):
	cells.set_cell_id(x,y,Id.WATER)

func getId():
	return Id.WORM

func draw():
	return _col
 
func update(cells, light, x: int, y: int):
	still_time += 1
	if still_time >= 10:
		cells.set_cell_id(x, y, Id.DIRT)
		return
	if !is_head:
		return
	directions.shuffle()
	for d in directions:
		var dx = d[0]
		var dy = d[1]
		var next_cell = cells.get_cell_id(x+dx, y+dy)
		if !can_move(next_cell):
			continue
		
		# this is the only cell in the worm
		if cells.get_cell_id(next_segment[0], next_segment[1]) != Id.WORM:
			cells.set_cell_id(x+dx, y+dy, Id.WORM, {"is_head": true, "next_segment": [x, y]})
			
		elif can_eat(next_cell):
			cells.set_cell_id(x+dx, y+dy, Id.WORM, {"is_head": true, "next_segment": next_segment})
		else:
			cells.swap_cell(x+dx, y+dy, next_segment[0], next_segment[1])
			var new_head = cells.get_cell(x+dx, y+dy)
			new_head.is_head = true
		is_head = false
		next_segment = [x+dx, y+dy]
		still_time = 0
		return

func can_move(id):
	return id in [
		Id.SAND,
		Id.DIRT,
		Id.FLOWER_1,
		Id.GRASS,
		Id.KELP,
		Id.STONE,
	]

func can_eat(id):
	return id in [
		Id.FLOWER_1,
		Id.GRASS,
		Id.KELP,
	]
