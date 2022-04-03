extends Cell
class_name BirdCell

var _col: Color

var dying: bool = false


func _init():
    self._col = Color(0.8,0.9,0)#Color(rand_range(0.6,0.8),rand_range(0.6,0.8),rand_range(0.4,0.6),1)

func kill(cells, x, y):
    cells.set_cell_id(x,y,Id.AIR)

func getId():
    return Id.FISH

func draw():
    return _col
 
var dx = -1;
func update(cells, light, x: int, y: int):
    
    var dy = randi()%3-1;
    var l = light[x][y]
        
    
    
    
    if dx == 0 && dy == 0:
        return
    
    var px = x + dx
    var py = y + dy
    
    
    
    var neighborCell = cells.get_cell_id(px,py)
    
    #if (neighborCell == Id.FISH):
    #    cells.kill(px,py)
    #    dx*=-1;
    if (neighborCell == Id.AIR):
        cells.swap_cell(x, y, px, py)
    else:
        dx*=-1
        #dying = false
    #elif (neighborCell == Id.KELP):
    #    dx*=-1;
    #    cells.kill(px,py)
    #    cells.set_cell(px,py,self)
    #else:
    #    dx*=-1;
