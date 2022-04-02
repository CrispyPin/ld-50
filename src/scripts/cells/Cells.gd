extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name Cells



var cells = []

var light = []

var draw

# get id at coordinates

func bounds_check(x: int, y: int) -> bool:
    return !(x<0 || y<0 || x>=draw.size[0] || y>= draw.size[1])

func get_cell_id(x: int, y: int) -> int:
    if bounds_check(x,y):
        return cells[x][y].getId()
    else:
        print("Get cell id invalid coordinate", x, y)
        return Cell.Id.AIR
    
func set_cell_id(x: int, y: int, id):
    set_cell(x,y,make_cell_from_id(id))
    
# creates a new cell with specified id
func make_cell_from_id(id) -> Cell:
    if id == Cell.Id.WALL:
        return WallCell.new()
    if id == Cell.Id.WATER:
        return WaterCell.new()
    if id == Cell.Id.SAND:
        return SandCell.new()
    if id == Cell.Id.FISH:
        return FishCell.new()
    else:
        if !id == Cell.Id.AIR:
            print("INVALID CELL ID REQUESTED:")
            print(id)
        return AirCell.new()

func get_cell(x: int, y: int):
    #return cells[x%draw.size[0]][y%draw.size[1]]
    if !bounds_check(x,y):
        print("Get cell invalid coordinate", x, y)
        return make_cell_from_id(Cell.Id.AIR)
    return cells[x][y]

func set_cell(x: int, y: int, cell):
    #cells[x%draw.size[0]][y%draw.size[1]] = cell
    if bounds_check(x,y):
        cells[x][y] = cell

func swap_cell(x1: int, y1: int, x2: int, y2: int):
    if !bounds_check(x1,y1) || !bounds_check(x2,y2):
        print("SWAP WITH INVALID LOCATION")
    var tmp = get_cell(x1,y1)
    set_cell(x1,y1, get_cell(x2,y2))
    set_cell(x2,y2, tmp)

func _ready():
    draw = get_parent()
    for x in range(draw.size[0]):
        cells.append([])
        light.append([])
        for y in range(draw.size[1]):
            var r = rand_range(0,1)
            light[x].append(rand_range(0,1))
            
            if x!=0 && y!=0 && x!=draw.size[0]-1 && y!=draw.size[1]-1:
                var u = (float(x)/draw.size[0]-0.5)*2.0
                var v = (float(y)/draw.size[1]-0.5)*2.0
                if v>sin(-u*2.0)*0.5+0.40:
                    cells[x].append(SandCell.new())
                elif v<0.2:
                    cells[x].append(AirCell.new())
                else:
                    cells[x].append(WaterCell.new())
            else:
                cells[x].append(WallCell.new())
    
    pass # Replace with function body.
    
func _update_light(x: int, y: int):
    var id = get_cell_id(x,y)
    var rval = 0.0
    
    var l_old = light[x][y]
    if id == Cell.Id.WALL:
        light[x][y] = 1.0
    else:
        var xp = x-1
        var yp = y-1
        
        var dl = 0.7
        
        var idp = get_cell_id(xp,yp)
        
        if idp == Cell.Id.AIR:
            dl = 1.0
            #return light[xp][yp]
        elif idp == Cell.Id.WATER:
            dl = 0.9
        
        rval = light[xp][yp] * dl
        light[x][y] = rval
        
        if rval!=l_old:
            _update_light(xp,yp)
        
        
func _update_color(x: int, y: int):
    var col = cells[x][y].draw()
    var r = col.r*col.r;
    var g = col.g*col.g;
    var b = col.b*col.b;
            
            
    var l = light[x][y]
    # linear color space light
    r = r * l
    g = g * l
    b = b * l
            
    # non-linear color
    r = sqrt(r)
    g = sqrt(g)
    b = sqrt(b)
        
    draw.set_pixel (x, y, Color(r,g,b))
    

func _process(delta):
    for i in range(draw.size[0]*20):
        var x = randi()%draw.size[0]
        var y = randi()%draw.size[1]
        cells[x][y].update(self, x, y)
    for i in range(draw.size[0]*5):
        var x = randi()%draw.size[0]
        var y = randi()%draw.size[1]
        _update_light(x,y)
    

        
    for x in range(draw.size[0]):
        for y in range(draw.size[1]):
            # non-linear color
            var col = cells[x][y].draw()
            var r = col.r*col.r;
            var g = col.g*col.g;
            var b = col.b*col.b;
            
            
            var l = light[x][y]
            # linear color space light
            r = r * l
            g = g * l
            b = b * l
            
            # non-linear color
            r = sqrt(r)
            g = sqrt(g)
            b = sqrt(b)
        
            draw.set_pixel (x, y, Color(r,g,b))
            #draw.set_pixel ( rand_range(0,draw.size[0]), rand_range(0,draw.size[1]), Color(rand_range(0,1),rand_range(0,1),rand_range(0,1),1))



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
