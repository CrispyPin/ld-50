extends Cell
class_name SandCell

var _col: Color


func _init():
    self._col = Color(0.7,0.7,0.5)*rand_range(1.1,0.9)#Color(rand_range(0.6,0.8),rand_range(0.6,0.8),rand_range(0.4,0.6),1)

func getId():
    return Id.SAND

func draw():
    return _col
 
func update(cells, _light, x: int, y: int):
    var dx = randi()%3-1;
    
    
    var neighborCell = cells.get_cell_id(x+dx,y+1)
    
    if (neighborCell == Id.AIR || neighborCell == Id.WATER):
        cells.swap_cell(x, y, x+dx, y+1)
        
        
        #cells[x][y] = AirCell.new()   

