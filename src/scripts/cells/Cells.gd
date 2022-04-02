extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name Cells

var cells = []

var draw

# Called when the node enters the scene tree for the first time.
func getCell(x: int, y: int):
    return cells[x%draw.size[0]][y%draw.size[1]]

func setCell(x: int, y: int, cell):
    cells[x%draw.size[0]][y%draw.size[1]] = cell

func swapCell(x1: int, y1: int, x2: int, y2: int):
    var tmp = getCell(x1,y1)
    setCell(x1,y1, getCell(x2,y2))
    setCell(x2,y2, tmp)

func _ready():
    draw = get_parent()
    for x in range(draw.size[0]):
        cells.append([])
        for y in range(draw.size[1]):
            if rand_range(0,1)>0.5:
                cells[x].append(SimpleCell.new(Color(rand_range(0,1),rand_range(0,1),rand_range(0,1),1)))
            else:
                cells[x].append(AirCell.new())
            
    
    pass # Replace with function body.
func _process(delta):
    for i in range(draw.size[0]*20):
        var x = randi()%draw.size[0]
        var y = randi()%draw.size[1]
        cells[x][y].update(self, x, y)
    

        
    for x in range(draw.size[0]):
        for y in range(draw.size[1]):
            draw.set_pixel (x, y, cells[x][y].draw())
            #draw.set_pixel ( rand_range(0,draw.size[0]), rand_range(0,draw.size[1]), Color(rand_range(0,1),rand_range(0,1),rand_range(0,1),1))



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
