extends Node
class_name Cells

var cells = []
var light = []
var draw

# for things that should never be out of bounds.
func bounds_check_safe(x: int, y: int) -> bool:
    return true#!(x<0 || y<0 || x>=draw.size[0] || y>=draw.size[1])

func bounds_check(x: int, y: int) -> bool:
    #print(draw.size,", ",x,", ",y)
    return !(x<0 || y<0 || x>=draw.size[0] || y>=draw.size[1])

# pre: x, y in bounds
func get_cell_id(x: int, y: int) -> int:
    if bounds_check_safe(x,y):
        return cells[x][y].getId()
    else:
        print("Get cell id invalid coordinate", x, y)
        return Cell.Id.AIR

# pre: x, y in bounds
func kill(x: int, y: int):
    get_cell(x,y).kill(self,x,y)

# pre: x, y in bounds
func set_cell_id_safe(x: int, y: int, id):
    if get_cell_id(x,y)!=Cell.Id.WALL:
        set_cell(x,y,make_cell_from_id(id))

# pre: x, y in bounds
func set_cell_id(x: int, y: int, id, args=[]):
    set_cell(x,y,make_cell_from_id(id, args))


# creates a new cell with specified id
static func make_cell_from_id(id, args=[]): # -> Cell
    match id:
        Cell.Id.WALL:
            return WallCell.new()
        Cell.Id.STONE:
            return StoneCell.new()
        Cell.Id.WATER:
            return WaterCell.new()
        Cell.Id.SAND:
            return SandCell.new()
        Cell.Id.DIRT:
            return DirtCell.new()
        Cell.Id.FISH:
            return FishCell.new()
        Cell.Id.KELP:
            return KelpCell.new()
        Cell.Id.FIRE:
            return FireCell.new()
        Cell.Id.SMOKE:
            return SmokeCell.new()
        Cell.Id.GRASS:
            return GrassCell.new()
        Cell.Id.LAVA:
            return LavaCell.new()
        Cell.Id.WORM:
            var c = WormCell.new()
            if args:
                c.is_head = args["is_head"]
                c.next_segment = args["next_segment"]
            return c
        Cell.Id.TREE_1, Cell.Id.TREE_2, Cell.Id.FLOWER_1:
            var c = PlantCell.new()
            if args:
                c.type = args.type
                c.tex_x = args.tex_x
                c.tex_y = args.tex_y
                c.landed = args.landed
            else:
                c.type = PlantCell.type_ids.keys()[PlantCell.type_ids.values().find(id)]
            return c
        _:
            if id != Cell.Id.AIR:
                print("INVALID CELL ID REQUESTED:", id)
            return AirCell.new()

# pre: x, y in bounds
func get_cell(x: int, y: int):
    #return cells[x%draw.size[0]][y%draw.size[1]]
    if !bounds_check_safe(x,y):
        print("Get cell invalid coordinate", x, y)
        return make_cell_from_id(Cell.Id.AIR)
    return cells[x][y]

# pre: x, y in bounds
func set_cell(x: int, y: int, cell):
    #cells[x%draw.size[0]][y%draw.size[1]] = cell
    if bounds_check_safe(x,y):
        cells[x][y] = cell
        redraw(x,y)
    else:
        print("SET CELL IN INVALID LOCATION")

# pre: x, y in bounds
func swap_cell(x1: int, y1: int, x2: int, y2: int):
    if !bounds_check_safe(x1,y1) || !bounds_check_safe(x2,y2):
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
                
                #v+=rand_range(-1,1)*0.05
                
                var sd = sin(-u*2.0)*0.5+0.40-v
                
                var sd_overhang = cos(-u*2.0+2.0)*0.5+0.20-v
                
                if sd_overhang>sd+0.20 || u < -0.5:
                    sd_overhang = 1
                    
                var sd_overhang_abs = abs(sd_overhang)-0.1
                
                var sd_water = 0.2-v
                if sd_overhang_abs<0:
                    if sd_overhang<0:
                        cells[x].append(StoneCell.new())
                    else:
                        cells[x].append(DirtCell.new())
                elif sd<0:
                    if sd<-0.3:
                        if r>0.999:
                            cells[x].append(BirdCell.new())
                        else:
                            cells[x].append(AirCell.new())
                    elif sd<-0.2:
                        cells[x].append(StoneCell.new())
                    else:
                        if sd_water<rand_range(-1,1)*0.1:
                            cells[x].append(SandCell.new())
                        else:
                            cells[x].append(DirtCell.new())
                elif sd_water>0:
                    if r>0.999:
                        cells[x].append(BirdCell.new())
                    else:
                        cells[x].append(AirCell.new())
                else:
                    if r>0.995:
                        cells[x].append(FishCell.new())
                    else:
                        cells[x].append(WaterCell.new())
            else:
                cells[x].append(WallCell.new())
    
    for x in range(1, draw.size[0]-1):
        set_cell_id(x, draw.size[1]-2, Cell.Id.STONE)
        set_cell_id(x, draw.size[1]-3, Cell.Id.STONE)
        set_cell_id(x, draw.size[1]-4, Cell.Id.DIRT)
    
    for x in range(20, 60, 2):
        set_cell(x, 50, KelpCell.new())
        
    for x in range(50, 90, 5):
        set_cell(x, 20, GrassCell.new())

    set_cell_id(135,40,Cell.Id.FLOWER_1)
    set_cell_id(150,40,Cell.Id.TREE_1)
    set_cell_id(170,40,Cell.Id.TREE_1)
    set_cell_id(185,40,Cell.Id.TREE_2)
    set_cell_id(190,40,Cell.Id.GRASS)

    
    for x in range(draw.size[0]):
        _update_light(x,0)
    for y in range(draw.size[1]):
        _update_light(0,y)
    
    #for y in range(draw.size[1]):         
    #    for x in range(draw.size[0]):
    #        _update_light(x,y)

# pre: x, y in bounds
func redraw(x: int, y: int):
    #if bounds_check_safe(x, y):
    _update_light(x,y)

func _update_light(x: int, y: int):
    _update_light_inner(x,y,true)

func _update_light_inner(x: int, y: int, unconditional_recursion: bool):
    var id = get_cell_id(x,y)
    
    var dx = 1
    
    var x_above = x - dx
    var y_above = y - 1
    
    var x_below = x + dx
    var y_below = y + 1
    
    var old_light = light[x][y]
    var new_light = 0.0
    if id == Cell.Id.WALL:
        new_light = 1.0
    else:
        
        
        if false:#id == Cell.Id.FIRE:
            new_light = 1.0
        else:
            var id_above = get_cell_id(x_above,y_above)
            var dl = 0.7
            if Cell.is_gas(id_above) || id_above == Cell.Id.WALL:
                dl = 1.0
                #return light[xp][yp]
            elif Cell.is_liquid(id_above):
                dl = 0.95
            new_light = light[x_above][y_above] * dl
        
    light[x][y] = new_light
    _update_color(x, y)
    if bounds_check(x_below, y_below) and (old_light != new_light or unconditional_recursion):
        _update_light_inner(x_below,y_below,false)
    
        
        
func _update_color(x: int, y: int):
    var col = cells[x][y].draw()
    var r = col.r*col.r;
    var g = col.g*col.g;
    var b = col.b*col.b;
    
    
    var min_l = 0.05
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
    
func update_simulation():
    for _i in range(draw.size[0] * Global.settings["update_rate"]):
        var x = randi()%draw.size[0]
        var y = randi()%draw.size[1]
        cells[x][y].update(self, light, x, y)
        
    if rand_range(0,1)>0.8:
        var x = randi()%draw.size[0]
        var y = randi()%draw.size[1]
        var id = get_cell_id(x,y)
        if Cell.is_flammable(id):
            set_cell_id(x, y, Cell.Id.FIRE)

func _process(_delta):
    update_simulation()
    

    #for i in range(draw.size[0]*5):
    #    var x = randi()%draw.size[0]
    #    var y = randi()%draw.size[1]
    #   _update_light(x,y)

    #for x in range(draw.size[0]):
    #    for y in range(draw.size[1]):
    #       _update_color(x, y)
