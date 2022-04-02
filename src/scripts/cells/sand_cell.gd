extends Cell


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name SandCell

var _col: Color

# Called when the node enters the scene tree for the first time.
func _init():
    self._col = Color(0.7,0.7,0.5)#Color(rand_range(0.6,0.8),rand_range(0.6,0.8),rand_range(0.4,0.6),1)

func getId():
    return Id.SAND

func draw():
    return _col
 
func update(cells, light, x: int, y: int):
    var dx = randi()%3-1;
    
    
    var neighborCell = cells.get_cell_id(x+dx,y+1)
    #var neighborCell = cells.getCell(x+dx,y+1)
    
    #if (neighborCell is AirCell || neighborCell is WaterCell):
    if (neighborCell == Id.AIR || neighborCell == Id.WATER):
        cells.swap_cell(x, y, x+dx, y+1)
        
        
        #cells[x][y] = AirCell.new()   

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
