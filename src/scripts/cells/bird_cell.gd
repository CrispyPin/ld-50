extends Cell
class_name BirdCell

var _col: Color

var dx = -1;
var held_seed

func _init():
	self._col = Color(0.0,0.6,1.0)#Color(rand_range(0.6,0.8),rand_range(0.6,0.8),rand_range(0.4,0.6),1)

func kill(cells, x, y):
	cells.set_cell_id(x,y,Id.AIR)

func getId():
	return Id.BIRD

func draw():
	return _col
 
func update(cells, _light, x: int, y: int):
	if held_seed != null and randf() < 0.02:
		var space_below = cells.get_cell_id(x, y+1)
		if is_fluid(space_below):
			cells.set_cell_id(x, y+1, held_seed)
			held_seed = null
	
	var dy = randi() % 3 - 1;
	var px = x + dx
	var py = y + dy
	
	var neighborCell = cells.get_cell_id(px,py)
	
	if is_gas(neighborCell):
		cells.swap_cell(x, y, px, py)
	else:
		dx*=-1
		if is_plant(neighborCell):
			held_seed = neighborCell
