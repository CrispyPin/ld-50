extends Cell


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name FishCell

var _col: Color

var dying: bool = false

# Called when the node enters the scene tree for the first time.
func _init():
    self._col = Color.from_hsv(rand_range(0,0.1),1,1)#Color(rand_range(0.6,0.8),rand_range(0.6,0.8),rand_range(0.4,0.6),1)

func kill(cells, x, y):
    cells.set_cell_id(x,y,Id.WATER)

func getId():
    return Id.FISH

func draw():
    return _col
 
var dx = -1;
func update(cells, _light, x: int, y: int):
    
    var dy = randi()%3-1;
    
    if dx == 0 && dy == 0:
        return
    
    var px = x + dx
    var py = y + dy
    
    
        
    
    var neighborCell = cells.get_cell_id(px,py)
    
    
    
    #var neighborCell = cells.getCell(x+dx,y+1)
    
    #if (neighborCell is AirCell || neighborCell is WaterCell):
    if (neighborCell == Id.FISH):
        cells.kill(px,py)
        dx*=-1;
    elif (neighborCell == Id.WATER):
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
        
    #if light[x + dx][py]>light[x - dx][py]:
    #    dx*=-1;
        
        
            
            
        
        
        #cells[x][y] = AirCell.new()   

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
