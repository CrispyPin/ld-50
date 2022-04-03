extends Cell
class_name SmokeCell

var _col: Color

func _init():
    self._col = Color(0.6,0.6,0.6) #Color(rand_range(0.0,0.2),rand_range(0.0,0.2),rand_range(0.4,1.0),1)*2.0

func getId():
    return Id.SMOKE

func draw():
    return _col
 
func kill(cells, x, y):
    if randf()>0.5:
        cells.set_cell_id(x,y,Id.AIR)
    else:
        cells.set_cell_id(x,y,Id.WATER)

func update(cells, _light, x: int, y: int):
    if rand_range(0,1)>0.96:
        kill(cells, x, y)
    var dx = randi()%3-1;
    var dy = -1
    if dx != 0:
        dy = 0
    
    var neighborcell = cells.get_cell_id(x+dx,y+dy)
    
    
    if neighborcell == Id.AIR:
        cells.swap_cell(x, y, x+dx, y+dy)
