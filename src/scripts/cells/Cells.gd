extends Node


class_name Cells

var cells = []
var light = []
var draw

# get id at coordinates

func bounds_check(x: int, y: int) -> bool:
    return !(x<0 || y<0 || x>=draw.size[0] || y>=draw.size[1])

func get_cell_id(x: int, y: int) -> int:
    if bounds_check(x,y):
        return cells[x][y].getId()
    else:
        print("Get cell id invalid coordinate", x, y)
        return Cell.Id.AIR

func kill(x: int, y: int):
    get_cell(x,y).kill(self,x,y)

func set_cell_id_safe(x: int, y: int, id):
    if get_cell_id(x,y)!=Cell.Id.WALL:
        set_cell(x,y,make_cell_from_id(id))

func set_cell_id(x: int, y: int, id):
    set_cell(x,y,make_cell_from_id(id))
    
# creates a new cell with specified id
func make_cell_from_id(id): # -> Cell
    if id == Cell.Id.WALL:
        return WallCell.new()
    if id == Cell.Id.WATER:
        return WaterCell.new()
    if id == Cell.Id.SAND:
        return SandCell.new()
    if id == Cell.Id.FISH:
        return FishCell.new()
    if id == Cell.Id.KELP:
        return KelpCell.new()
    if id == Cell.Id.TREE:
        return TreeCell.new()
    if id == Cell.Id.TREE2:
        var c = TreeCell.new()
        c.type = "tree_2"
        return c
    if id == Cell.Id.FLOWER1:
        var c = TreeCell.new()
        c.type = "flower_1"
        return c
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
        redraw(x,y)
        

func swap_cell(x1: int, y1: int, x2: int, y2: int):
    if !bounds_check(x1,y1) || !bounds_check(x2,y2):
        print("SWAP WITH INVALID LOCATION")
    var tmp = get_cell(x1,y1)
    set_cell(x1,y1, get_cell(x2,y2))
    set_cell(x2,y2, tmp)

func _ready():
    draw = get_parent()

    
    yield(draw, "ready")

    
    for x in range(draw.size[0]):
        cells.append([])
        light.append([])
        for y in range(draw.size[1]):
            var r = rand_range(0,1)
            light[x].append(0.0)
            
            if x!=0 && y!=0 && x!=draw.size[0]-1 && y!=draw.size[1]-1:
                var u = (float(x)/draw.size[0]-0.5)*2.0
                var v = (float(y)/draw.size[1]-0.5)*2.0
                if v>sin(-u*2.0)*0.5+0.40:
                    cells[x].append(SandCell.new())
                elif v<0.2:
                    cells[x].append(AirCell.new())
                else:
                    if r>1.98:
                        cells[x].append(FishCell.new())
                    else:
                        cells[x].append(WaterCell.new())
            else:
                cells[x].append(WallCell.new())
    
    for x in range(20, 60, 2):
        set_cell(x, 50, KelpCell.new())

    set_cell(150,40,TreeCell.new())
    set_cell(170,40,TreeCell.new())
    set_cell_id(185,40,Cell.Id.TREE2)
    set_cell_id(135,40,Cell.Id.FLOWER1)

    
    for x in range(draw.size[0]):
        _update_light(x,0)
    for y in range(draw.size[1]):
        _update_light(0,y)
    
    #for y in range(draw.size[1]):         
    #    for x in range(draw.size[0]):
    #        _update_light(x,y)

func redraw(x: int, y: int):
    if bounds_check(x, y):
        _update_light(x,y)

func _update_light(x: int, y: int):
    _update_light_inner(x,y,true)

func _update_light_inner(x: int, y: int, unconditional_recursion: bool):
    var id = get_cell_id(x,y)
    
    var dx = 1
    
    
    var x_above = x-dx
    var y_above = y-1
    
    var x_below = x+dx
    var y_below = y+1
    
    var old_light = light[x][y]
    var new_light = 0.0
    if id == Cell.Id.WALL:
        new_light = 1.0
    else:
        
        
        var id_above = get_cell_id(x_above,y_above)
        
        var dl = 0.7
        if id_above == Cell.Id.AIR || id_above == Cell.Id.WALL:
            dl = 1.0
            #return light[xp][yp]
        elif id_above == Cell.Id.WATER:
            dl = 0.95
        
        new_light = light[x_above][y_above] * dl
        
        
        
        #if new_light!=old_light:
        #    pass
        
        # cell below
    light[x][y] = new_light
    _update_color(x, y)
    if bounds_check(x_below, y_below) and (old_light != new_light or unconditional_recursion):
        _update_light_inner(x_below,y_below,false)
    
        
        
func _update_color(x: int, y: int):
    var col = cells[x][y].draw()
    var r = col.r*col.r;
    var g = col.g*col.g;
    var b = col.b*col.b;
            
    
    var min_l = 0.01
    var l = (light[x][y]+min_l)/(1.0+min_l)
    # linear color space light
    r = r * l
    g = g * l
    b = b * l
            
    # non-linear color
    r = sqrt(r)
    g = sqrt(g)
    b = sqrt(b)
        
    draw.set_pixel (x, y, Color(r,g,b))
    

func _process(_delta):
    for _i in range(draw.size[0]*20):
        var x = randi()%draw.size[0]
        var y = randi()%draw.size[1]
        cells[x][y].update(self, light, x, y)
    #for i in range(draw.size[0]*5):
    #    var x = randi()%draw.size[0]
    #    var y = randi()%draw.size[1]
    #   _update_light(x,y)


    #for x in range(draw.size[0]):
    #    for y in range(draw.size[1]):
    #       _update_color(x, y)
