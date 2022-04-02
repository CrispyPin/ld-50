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

func draw():
    return _col
 
func update(cells, light, x: int, y: int):

    if falling:
        var neighborCell = cells.get_cell_id(x,y+1)

        if (neighborCell == Id.WATER || neighborCell == Id.AIR):
            cells.swap_cell(x, y, x, y+1)
        else:
            falling = false

        
            
            
        
        
        #cells[x][y] = AirCell.new()   

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
