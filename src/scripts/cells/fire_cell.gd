extends Cell
class_name FireCell

var _col: Color

func _init():
    self._col = Color(1.0,0.2,0.0) #Color(rand_range(0.0,0.2),rand_range(0.0,0.2),rand_range(0.4,1.0),1)*2.0

func getId():
    return Id.FIRE

func draw():
    return _col
 
func kill(cells, x, y):
	cells.set_cell_id(x,y,Id.SMOKE if rand_range(0,1)>0.5 else Id.AIR)

func update(cells, _light, x: int, y: int):
    if randi()%10!=0:
        return
    var dx = randi()%3-1;
    var dy = randi()%3-1
    if dx == 0 && dy == 0:
        return
        
    var px = x + dx
    var py = y + dy
    
    var id = cells.get_cell_id(px,py)
    
    var r = rand_range(0,1)
    
    if Cell.is_flammable(id):
        cells.kill(px, py)
        cells.set_cell_id(px, py, Id.FIRE)
    elif id == Id.WATER || (r>0.95 && id != Id.AIR) || r > 0.98:
        kill(cells,x,y)
    elif id == Id.AIR:
        kill(cells,x,y)
