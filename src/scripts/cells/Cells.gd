extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name Cells



var cells = []

var draw

# get id at coordinates
func get_cell_id(x: int, y: int):
    return cells[x][y].getId()
    
func set_cell_id(x: int, y: int, id):
    set_cell(x,y,make_cell_from_id(id))
    
# creates a new cell with specified id
func make_cell_from_id(id):
    if id == Cell.Id.AIR:
        return AirCell.new()
    if id == Cell.Id.WALL:
        return WallCell.new()
    if id == Cell.Id.WATER:
        return WaterCell.new()
    if id == Cell.Id.SAND:
        return SandCell.new()

func get_cell(x: int, y: int):
    #return cells[x%draw.size[0]][y%draw.size[1]]
    return cells[x][y]

func set_cell(x: int, y: int, cell):
    #cells[x%draw.size[0]][y%draw.size[1]] = cell
    cells[x][y] = cell

func swap_cell(x1: int, y1: int, x2: int, y2: int):
    var tmp = get_cell(x1,y1)
    set_cell(x1,y1, get_cell(x2,y2))
    set_cell(x2,y2, tmp)

func _ready():
    draw = get_parent()
    for x in range(draw.size[0]):
        cells.append([])
        for y in range(draw.size[1]):
            var r = rand_range(0,1)
            if x!=0 && y!=0 && x!=draw.size[0]-1 && y!=draw.size[1]-1:
                if r>0.8:
                    cells[x].append(SandCell.new())
                elif r>0.4:
                    cells[x].append(AirCell.new())
                else:
                    cells[x].append(WaterCell.new())
            else:
                cells[x].append(WallCell.new())
    
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
