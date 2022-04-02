extends Cell


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name SimpleCell

var _col: Color

# Called when the node enters the scene tree for the first time.
func _init(col: Color):
    self._col = col

func draw():
    return _col
 
func update(cells, x: int, y: int):
    var dx = randi()%3-1;
    
    var neighborCell = cells.getCell(x+dx,y+1)
    
    if (neighborCell is AirCell || neighborCell is WaterCell):
        cells.swapCell(x, y, x+dx, y+1)
        
        
        #cells[x][y] = AirCell.new()   

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
