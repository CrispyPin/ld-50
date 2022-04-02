extends Object


class_name Cell

enum Id {
    AIR,
    WALL,
    WATER,
    SAND,
    FISH,
    KELP,
    TREE,
    TREE2,
    FLOWER1,
}

func kill(cells, x, y):
    cells.set_cell_id(x,y,Id.AIR)


func getId():
    return Id.AIR


func has_nearby(cells, x: int, y: int, id) -> bool:
    for dx in range(-1,2):
        for dy in range(-1,2):
            if cells.get_cell(x+dx,y+dy).getId() == id:
                return true
    return false

func is_in_water(cells, x, y) -> bool:
    return has_nearby(cells, x, y, Id.WATER)

func draw():
    return Color(0,0,0,1)
    
func update(_cells, _light, _x: int, _y: int):
    pass

