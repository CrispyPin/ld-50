extends Cell


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name KelpCell

var _col: Color

var falling: bool = true

# Called when the node enters the scene tree for the first time.
func _init():
    self._col = Color(0.0, 1.0, 0.0)#Color(rand_range(0.6,0.8),rand_range(0.6,0.8),rand_range(0.4,0.6),1)

func getId():
    return Id.KELP
    
func kill(cells, x, y):
    cells.set_cell_id(x,y,Id.WATER)
    if cells.get_cell_id(x,y-1) == Id.KELP:
        cells.kill(x,y-1)

func draw():
    return _col
 
func update(cells, light, x: int, y: int):
    if falling:
        var neighborCell = cells.get_cell_id(x,y+1)#

        if (neighborCell == Id.WATER || neighborCell == Id.AIR || neighborCell == Id.FISH):
            cells.swap_cell(x, y, x, y+1)
        else:
            falling = false
            if !is_in_water(cells, x, y):
                cells.kill(x,y)
    else: 
        if light[x][y] < 0.9:
            var yp = y-1
            var xp = x
            var neighborCell = cells.get_cell_id(x,yp)
            if neighborCell == Id.WATER:
                cells.set_cell_id(xp,yp,Id.KELP)
                cells.get_cell(xp,yp).update(cells, light, xp, yp)
        
            
            
        
        
        #cells[x][y] = AirCell.new()   

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
