extends Cell


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name WaterCell
    

func draw():
    return Color(0.4,0.4,1)
 
func update(cells, x: int, y: int):
    var dx = randi()%3-1;
    var dy = 1
    if dx != 0:
        dy = 0

    if cells.getCell(x+dx,y+dy) is AirCell:
        cells.swapCell(x, y, x+dx, y+dy)
        
        
        #cells[x][y] = AirCell.new()   

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
