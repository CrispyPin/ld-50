extends Cell
class_name KelpCell

var _col: Color

var falling: bool = true

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
    Global.time_since_update["kelp"] = 0
    if true:
        var neighborCell = cells.get_cell_id(x, y+1)

        if (neighborCell == Id.WATER || neighborCell == Id.AIR || neighborCell == Id.FISH):
            cells.swap_cell(x, y, x, y + 1)
            return
        elif falling:
            falling = false

    if !falling:
        if rand_range(0,1) > 0.3:
            if !is_in_water(cells, x, y):
                cells.kill(x,y)
            elif light[x][y] > rand_range(0,1) && light[x][y] < 0.5:
                var yp = y-1
                var xp = x + randi()%3-1
                var neighborCell = cells.get_cell_id(x,yp)
                if neighborCell == Id.WATER:
                    cells.set_cell_id_safe(xp,yp,Id.KELP)
                #cells.get_cell(xp,yp).update(cells, light, xp, yp)
