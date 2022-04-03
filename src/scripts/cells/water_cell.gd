extends Cell
class_name WaterCell

var _col: Color

func _init():
    self._col = Color(0.2,0.2,1.0) 
    self._col = Color(rand_range(0.15,0.25),rand_range(0.15,0.25),rand_range(0.9,1.0))

func kill(cells, x, y):
	cells.set_cell_id(x,y,Id.SMOKE)

func getId():
    return Id.WATER

func draw():
    return _col
 
func update(cells, _light, x: int, y: int):
    if randi()%1000==0:
        cells.kill(x,y)
    
    var dx = randi()%3-1;
    var dy = 1
    if dx != 0:
        dy = 0
        
    var px = x + dx
    var py = y + dy
    
    var neighborcell = cells.get_cell_id(px,py)
    
    
    if is_gas(neighborcell):
        cells.swap_cell(x, y, px, py)
    elif neighborcell == Id.FIRE:
        cells.kill(x,y)
        cells.kill(px,py)
