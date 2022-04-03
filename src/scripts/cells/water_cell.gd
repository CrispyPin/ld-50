extends Cell
class_name WaterCell

var _col: Color

func _init():
    self._col = Color(0.2,0.2,1.0) #Color(rand_range(0.0,0.2),rand_range(0.0,0.2),rand_range(0.4,1.0),1)*2.0

func getId():
    return Id.WATER

func draw():
    return _col
 
func update(cells, _light, x: int, y: int):
    var dx = randi()%3-1;
    var dy = 1
    if dx != 0:
        dy = 0
    
    var neighborcell = cells.get_cell_id(x+dx,y+dy)
    
    
    if neighborcell == Id.AIR:
        cells.swap_cell(x, y, x+dx, y+dy)
