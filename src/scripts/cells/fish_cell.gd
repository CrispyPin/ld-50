extends Cell


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name FishCell

var _col: Color

# Called when the node enters the scene tree for the first time.
func _init():
    self._col = Color.from_hsv(rand_range(0,0.5),1,1)#Color(rand_range(0.6,0.8),rand_range(0.6,0.8),rand_range(0.4,0.6),1)

func getId():
    return Id.FISH

func draw():
    return _col
 
func update(cells, x: int, y: int):
    var dx = randi()%3-1;
    var dy = randi()%3-1;

    
    var neighborCell = cells.get_cell_id(x+dx,y+dy)
    #var neighborCell = cells.getCell(x+dx,y+1)
    
    #if (neighborCell is AirCell || neighborCell is WaterCell):
    if (neighborCell == Id.WATER):
        cells.swap_cell(x, y, x+dx, y+dy)
    elif (neighborCell == Id.AIR):
        cells.set_cell(x, y, SandCell.new())
            
            
        
        
        #cells[x][y] = AirCell.new()   

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
