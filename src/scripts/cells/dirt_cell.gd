extends Cell
class_name DirtCell


func getId():
	return Id.DIRT

func draw():
	return Color(0.35, 0.25, 0.1)
 

func update(cells, _light, x: int, y: int):
	var neighborCell = cells.get_cell_id(x, y + 1)
	if (is_gas(neighborCell) || is_liquid(neighborCell)):
		cells.swap_cell(x, y, x, y + 1)
	
