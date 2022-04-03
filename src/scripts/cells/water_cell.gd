extends Cell
class_name WaterCell

var _col: Color

func _init():
    self._col = Color(0.2,0.2,1.0) #Color(rand_range(0.0,0.2),rand_range(0.0,0.2),rand_range(0.4,1.0),1)*2.0

func kill(cells, x, y):
	cells.set_cell_id(x,y,Id.SMOKE)

func getId():
    return Id.WATER

func draw():
    return _col
 
func update(cells, _light, x: int, y: int):
    if randi()%500==0:
        if cells.get_cell_id(x, y-1) == Id.AIR:
            cells.kill(x,y)
            return

        
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
