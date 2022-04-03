extends Cell
class_name FishCell

var _col: Color

var dying: bool = false


func _init():
    self._col = Color.from_hsv(rand_range(0,0.1),1,1)#Color(rand_range(0.6,0.8),rand_range(0.6,0.8),rand_range(0.4,0.6),1)

func kill(cells, x, y):
    cells.set_cell_id(x,y,Id.WATER)

func getId():
    return Id.FISH

func draw():
    return _col
 
var dx = -1;
func update(cells, light, x: int, y: int):
    
    var dy = randi()%3-1;
    var l = light[x][y]
    if rand_range(0,1)<0.8:
        if l>0.6:
            dy = 1
        elif l<0.3:
            dy = -1
        
    
    
    
    if dx == 0 && dy == 0:
        return
    
    var px = x + dx
    var py = y + dy
    
    
    
    var neighborCell = cells.get_cell_id(px,py)
    
    if (neighborCell == Id.FISH):
        cells.kill(px,py)
        dx*=-1;
    elif is_moist(neighborCell):
        cells.swap_cell(x, y, px, py)
        dying = false
    elif (neighborCell == Id.AIR):
        if dying:
            cells.kill(x, y)
        dying = true
    elif (neighborCell == Id.KELP):
        dx*=-1;
        cells.kill(px,py)
        cells.set_cell(px,py,self)
    else:
        dx*=-1;
